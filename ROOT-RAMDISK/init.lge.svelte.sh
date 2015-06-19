#!/system/bin/sh

start() {
  # Check the available memory
  memtotal_str=$(grep 'MemTotal' /proc/meminfo)
  memtotal_tmp=${memtotal_str#MemTotal:}
  memtotal_kb=${memtotal_tmp%kB}
  lowram_limitation=2097152

  echo MemTotal is $memtotal_kb kB

  if [ $memtotal_kb -gt $lowram_limitation ] ; then
    exit $?
  fi

  #check built-in zram devices
  nr_builtin_zram=$(ls /dev/block | grep -c zram)

  if [ "$nr_builtin_zram" -ne "0" ] ; then
    #use the built-in zram devices
    nr_zramdev=${nr_builtin_zram}
    use_mod=0
  else
    use_mod=1
    # Detect the number of cores
    nr_cores=$(grep -c ^processor /proc/cpuinfo)

    # Evaluate the number of zram devices based on the number of cores.
    nr_zramdev=${nr_cores/#0/1}
    echo The number of cores is $nr_cores
  fi
  echo zramdev $nr_zramdev

  # Evaluate the zram size for swap
  sz_zram=$((((memtotal_kb/3) / ${nr_zramdev}) * 1024))
  echo sz_zram size is ${sz_zram}

  # load kernel module for zram
  if [ "$use_mod" -eq "1"  ] ; then
    modpath=/system/lib/modules/zram.ko
    modargs="num_devices=${nr_zramdev}"
    echo zram.ko is $modargs

    if [ -f $modpath ] ; then
      insmod $modpath $modargs && (echo "zram module loaded") || (echo "module loading failed and exiting(${?})" ; exit $?)
    else
      echo "zram module not exist(${?})"
      exit $?
    fi
  fi

  # initialize and configure the zram devices as a swap partition
  zramdev_num=0
  while [[ $zramdev_num -lt $nr_zramdev ]]; do
    echo $sz_zram > /sys/block/zram${zramdev_num}/disksize
    mkswap /dev/block/zram${zramdev_num} && (echo "mkswap ${zramdev_num}") || (echo "mkswap ${zramdev_num} failed and exiting(${?})" ; exit $?)
    swapon -p 5 /dev/block/zram${zramdev_num} && (echo "swapon ${zramdev_num}") || (echo "swapon ${zramdev_num} failed and exiting(${?})" ; exit $?)
    ((zramdev_num++))
  done

  # tweak VM parameters considering zram/swap

  swappiness_new=80
  overcommit_memory=1
  page_cluster=0
  vfs_cache_pressure=10
  let min_free_kbytes=$(cat /proc/sys/vm/min_free_kbytes)*2
  # dirty_expire_centisecs=3000
  dirty_writeback_centisecs=500
  dirty_background_ratio=40
  dirty_ratio=80
  laptop_mode=0

  # KSM parameters
  pages_to_scan=100
  sleep_millisecs=500
  run=1

  echo $swappiness_new > /proc/sys/vm/swappiness
  echo $overcommit_memory > /proc/sys/vm/overcommit_memory
  echo $page_cluster > /proc/sys/vm/page-cluster
  echo $vfs_cache_pressure > /proc/sys/vm/vfs_cache_pressure
  echo $min_free_kbytes > /proc/sys/vm/min_free_kbytes
  # echo $dirty_expire_centisecs > /proc/sys/vm/dirty_expire_centisecs
  echo $dirty_writeback_centisecs > /proc/sys/vm/dirty_writeback_centisecs
  echo $dirty_background_ratio > /proc/sys/vm/dirty_background_ratio
  echo $dirty_ratio > /proc/sys/vm/dirty_ratio
  echo $laptop_mode > /proc/sys/vm/laptop_mode

  # Configure and enable KSM
  echo $pages_to_scan > /sys/kernel/mm/ksm/pages_to_scan
  echo $sleep_millisecs > /sys/kernel/mm/ksm/sleep_millisecs
  echo $run > /sys/kernel/mm/ksm/run

}

stop() {
  swaps=$(grep zram /proc/swaps)
  swaps=${swaps%%partition*}
  if [ $swaps ] ; then
    for i in $swaps; do
     swapoff $i
    done
    for j in $(ls /sys/block | grep zram); do
      echo 1 ${j}/reset
    done
    if [ $(lsmod | grep -c zram) -ne "0" ] ; then
      rmmod zram && (echo "zram unloaded") || (echo "zram unload fail(${?})" ; exit $?)
    fi
  fi
}

cmd=${1-start}

case $cmd in
  "start") start
  ;;
  "stop") stop
  ;;
  *) echo "Undefined command!"
  ;;
esac
