#!/sbin/busybox sh

# Kernel Tuning by Dorimanx.

BB=/sbin/busybox

# protect init from oom
echo "-1000" > /proc/1/oom_score_adj;

OPEN_RW()
{
	if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
		$BB mount -o remount,rw /;
	fi;
	if [ "$($BB mount | grep system | grep -c ro)" -eq "1" ]; then
		$BB mount -o remount,rw /system;
	fi;
}
OPEN_RW;

#selinux_status=$(grep -c "selinux=1" /proc/cmdline);
#if [ "$selinux_status" -eq "1" ]; then
#	restorecon -RF /system
#	if [ -e /system/bin/app_process32_xposed ]; then
#		chcon u:object_r:zygote_exec:s0 /system/bin/app_process32_xposed
#	fi;
#	umount /firmware;
#	mount -t vfat -o #ro,context=u:object_r:firmware_file:s0,shortname=lower,uid=1000,gid=1000,dmask=227,fmask=337 /#dev/block/platform/msm_sdcc.1/by-name/modem /firmware
#fi;

# run ROM scripts
$BB sh /init.qcom.post_boot.sh;

# clean old modules from /system and add new from ramdisk
if [ ! -d /system/lib/modules ]; then
        $BB mkdir /system/lib/modules;
fi;
cd /lib/modules/;
for i in *.ko; do
        $BB rm -f /system/lib/modules/"$i";
done;
cd /;

$BB chmod 755 /lib/modules/*.ko;
$BB cp -a /lib/modules/*.ko /system/lib/modules/;

# create init.d folder if missing
if [ ! -d /system/etc/init.d ]; then
	mkdir -p /system/etc/init.d/
	$BB chmod -R 755 /system/etc/init.d/;
fi;

OPEN_RW;

# start CROND by tree root, so it's will not be terminated.
$BB sh /res/crontab_service/service.sh;

# some nice thing for dev
if [ ! -e /cpufreq ]; then
	$BB ln -s /sys/devices/system/cpu/cpu0/cpufreq/ /cpufreq;
	$BB ln -s /sys/devices/system/cpu/cpufreq/ /cpugov;
	$BB ln -s /sys/module/msm_thermal/parameters/ /cputemp;
	$BB ln -s /sys/kernel/alucard_hotplug/ /hotplugs/alucard;
	$BB ln -s /sys/kernel/intelli_plug/ /hotplugs/intelli;
	$BB ln -s /sys/module/msm_hotplug/ /hotplugs/msm_hotplug;
	$BB ln -s /sys/devices/system/cpu/cpufreq/all_cpus/ /all_cpus;
fi;

CRITICAL_PERM_FIX()
{
	# critical Permissions fix
	$BB chown -R root:root /tmp;
	$BB chown -R root:root /res;
	$BB chown -R root:root /sbin;
	$BB chown -R root:root /lib;
	$BB chmod -R 777 /tmp/;
	$BB chmod -R 775 /res/;
	$BB chmod -R 06755 /sbin/ext/;
	$BB chmod 06755 /sbin/busybox;
	$BB chmod 06755 /system/xbin/busybox;
}
CRITICAL_PERM_FIX;

HORSETASTIC_TUNING()
{

sleep 5

echo 462400000 | tee /sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/max_gpuclk
echo 462400000 | tee /sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/devfreq/max_freq
echo 10 | tee /sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/devfreq/polling_interval
echo msm-adreno-tz | tee /sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/devfreq/governor
echo 1 | tee /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate
echo 4000 | tee /sys/module/simple_gpu_algorithm/parameters/simple_ramp_threshold
echo 6 | tee /sys/module/simple_gpu_algorithm/parameters/simple_laziness

# set cpu boost settings
echo 0 | tee /sys/module/cpu_boost/parameters/boost_ms
echo 0 | tee /sys/module/cpu_boost/parameters/input_boost_ms
echo 1036800 | tee /sys/module/cpu_boost/parameters/sync_threshold
echo 1036800 | tee /sys/module/cpu_boost/parameters/input_boost_freq

# Set screen levels
echo 250 252 256 | tee /sys/devices/platform/kcal_ctrl.0/kcal
echo 1 | tee /sys/devices/platform/kcal_ctrl.0/kcal_enable
echo 248 | tee /sys/devices/platform/kcal_ctrl.0/kcal_val
echo 253 | tee /sys/devices/platform/kcal_ctrl.0/kcal_cont

# Set hotplug and thermal settings
echo 0 > /sys/module/intelli_plug/parameters/intelli_plug_active
echo 0 | tee /sys/kernel/msm_mpdecision/conf/enabled
echo 0 | tee /sys/module/msm_thermal/vdd_restriction/enabled
echo Y | tee /sys/module/msm_thermal/parameters/enabled
echo 0 | tee /sys/module/msm_thermal/core_control/enabled
echo 1 | tee /sys/module/intelli_plug/parameters/touch_boost_active
echo 12 | tee /sys/module/intelli_plug/parameters/nr_run_hysteresis
echo 300000 | tee /sys/module/intelli_plug/parameters/screen_off_max
stop mpdecision
echo 0 | tee /sys/kernel/alucard_hotplug/hotplug_enable
echo 0 | tee /sys/kernel/alucard_hotplug/hotplug_suspend
echo 1 > /sys/module/msm_hotplug/msm_enabled
echo 1 > /sys/module/msm_hotplug/min_cpus_online
echo 1 > /sys/kernel/msm_mpdecision/conf/min_cpus
echo 1 > /sys/module/msm_hotplug/io_is_busy

# Set voltage levels
echo 745 745 745 745 755 765 775 795 805 835 845 870 915 975 1010 | tee /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

# Msc cpu tweaks
echo 0 | tee /sys/devices/system/cpu/sched_mc_power_savings
echo 1 | tee /sys/kernel/power_suspend/power_suspend_mode

# Set zram size
swapoff /dev/block/zram0
echo 1 > /sys/block/zram0/reset
echo 314572800 | tee /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0

# Tweak memory settings
echo 1053696 | tee /proc/sys/fs/nr_open
echo 32000 | tee /proc/sys/fs/inotify/max_queued_events
echo 256 | tee /proc/sys/fs/inotify/max_user_instances
echo 10240 | tee /proc/sys/fs/inotify/max_user_watches
echo 10 | tee /proc/sys/fs/lease-break-time
echo 165164 | tee /proc/sys/fs/file-max
echo 525810 | tee /proc/sys/kernel/threads-max
echo 256 | tee /proc/sys/kernel/random/write_wakeup_threshold
echo 128 | tee /proc/sys/kernel/random/read_wakeup_threshold
echo 1 | tee /proc/sys/kernel/sched_compat_yield
echo 5 | tee /proc/sys/kernel/panic
echo 1 | tee /proc/sys/kernel/panic_on_oops
echo 2048 | tee /proc/sys/kernel/msgmni
echo 64000 | tee /proc/sys/kernel/msgmax
echo 4096 | tee /proc/sys/kernel/shmmni
echo 2097152 | tee /proc/sys/kernel/shmall
echo 268435456 | tee /proc/sys/kernel/shmmax
echo 500 512000 64 2048 | tee /proc/sys/kernel/sem
echo 24189 | tee /proc/sys/kernel/sched_features
echo 30 | tee /proc/sys/kernel/hung_task_timeout_secs
echo 18000000 | tee /proc/sys/kernel/sched_latency_ns
echo 1500000 | tee /proc/sys/kernel/sched_min_granularity_ns
echo 3000000 | tee /proc/sys/kernel/sched_wakeup_granularity_ns
echo 256000 | tee /proc/sys/kernel/sched_shares_ratelimit
echo 0 | tee /proc/sys/kernel/sched_child_runs_first
echo 90 | tee /proc/sys/vm/dirty_ratio
echo 80 | tee /proc/sys/vm/dirty_background_ratio
echo 1 | tee /proc/sys/vm/oom_kill_allocating_task
echo 1 | tee /proc/sys/vm/overcommit_memory
echo 3 | tee /proc/sys/vm/page-cluster
echo 3 | tee /proc/sys/vm/drop_caches
echo 4096 | tee /proc/sys/vm/min_free_kbytes
echo 0 | tee /proc/sys/vm/panic_on_oom
echo 1000 | tee /proc/sys/vm/dirty_expire_centisecs
echo 2000 | tee /proc/sys/vm/dirty_writeback_centisecs
echo 60 | tee /proc/sys/vm/swappiness
echo 10 | tee /proc/sys/vm/vfs_cache_pressure
echo 4 | tee /proc/sys/vm/min_free_order_shift
echo 0 | tee /proc/sys/vm/laptop_mode
echo 0 | tee /proc/sys/vm/block_dump
echo 4096,8192,16384,32768,49152,65536 | tee /sys/module/lowmemorykiller/parameters/minfree

# Set read ahead
echo 2048 | tee /sys/block/mmcblk0/queue/read_ahead_kb
echo 2048 | tee /sys/block/mmcblk1/queue/read_ahead_kb

# Set minimum clock speed
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 300000 | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu1
echo 300000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu1
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu2
echo 300000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu2
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu3
echo 300000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu3
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu3

# Set cpu governor
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ondemand | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
echo ondemand | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
echo ondemand | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3
echo ondemand | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3

# Set i/o scheduler
echo fiops | tee /sys/block/mmcblk0/queue/scheduler
echo fiops | tee /sys/block/mmcblk1/queue/scheduler

# Set cpu max speed
echo 2265600 | tee /sys/kernel/msm_cpufreq_limit/cpufreq_limit
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1728000 | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
echo 1728000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
echo 2265600 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3
echo 2265600 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3

# Tweak ondemand governor settings
echo 30 | tee /sys/devices/system/cpu/cpufreq/ondemand/down_differential
echo 30 | tee /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
echo 95 | tee /sys/devices/system/cpu/cpufreq/ondemand/high_grid_load
echo 5 | tee /sys/devices/system/cpu/cpufreq/ondemand/high_grid_step
echo 1 | tee /sys/devices/system/cpu/cpufreq/ondemand/ignor_nice_load
echo 85 | tee /sys/devices/system/cpu/cpufreq/ondemand/middle_grid_load
echo 10 | tee /sys/devices/system/cpu/cpufreq/ondemand/middle_grid_step
echo 1267200 | tee /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
echo 1574400 | tee /sys/devices/system/cpu/cpufreq/ondemand/optimal_max_freq
echo 2 | tee /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo 100000 | tee /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
echo 1190400 | tee /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
echo 95 | tee /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
echo 95 | tee /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
echo 95 | tee /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core

}

# oom and mem perm fix
$BB chmod 666 /sys/module/lowmemorykiller/parameters/cost;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/adj;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/minfree

# make sure we own the device nodes
$BB chown system /sys/devices/system/cpu/cpufreq/ondemand/*
$BB chown system /sys/devices/system/cpu/cpu0/cpufreq/*
$BB chown system /sys/devices/system/cpu/cpu1/online
$BB chown system /sys/devices/system/cpu/cpu2/online
$BB chown system /sys/devices/system/cpu/cpu3/online
$BB chmod 666 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
$BB chmod 666 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
$BB chmod 666 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
$BB chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
$BB chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/stats/*
$BB chmod 666 /sys/devices/system/cpu/cpufreq/all_cpus/*
$BB chmod 666 /sys/devices/system/cpu/cpu1/online
$BB chmod 666 /sys/devices/system/cpu/cpu2/online
$BB chmod 666 /sys/devices/system/cpu/cpu3/online
$BB chmod 666 /sys/module/lm3697/parameters/lm3697_backlight_control
$BB chmod 666 /sys/module/lm3697/parameters/lm3697_max_backlight
$BB chmod 666 /sys/module/lm3697/parameters/lm3697_min_backlight
$BB chmod 666 /sys/module/msm_thermal/parameters/*
$BB chmod 666 /sys/kernel/intelli_plug/*
$BB chmod 666 /sys/class/kgsl/kgsl-3d0/max_gpuclk
$BB chmod 666 /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/governor
$BB chmod 666 /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/*_freq

# make sure our max gpu clock is set via sysfs
echo "27000000" > /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/min_freq
echo "450000000" > /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/max_freq

if [ ! -d /data/.gabriel ]; then
	$BB mkdir /data/.gabriel/;
fi;

# reset profiles auto trigger to be used by kernel ADMIN, in case of need, if new value added in default profiles
# just set numer $RESET_MAGIC + 1 and profiles will be reset one time on next boot with new kernel.
# incase that ADMIN feel that something wrong with global STweaks config and profiles, then ADMIN can add +1 to CLEAN_GABRIEL_DIR
# to clean all files on first boot from /data/.gabriel/ folder.
RESET_MAGIC=3;
CLEAN_GABRIEL_DIR=1;

if [ ! -e /data/.gabriel/reset_profiles ]; then
	echo "$RESET_MAGIC" > /data/.gabriel/reset_profiles;
fi;
if [ ! -e /data/reset_gabriel_dir ]; then
	echo "$CLEAN_GABRIEL_DIR" > /data/reset_gabriel_dir;
fi;
if [ -e /data/.gabriel/.active.profile ]; then
	PROFILE=$(cat /data/.gabriel/.active.profile);
else
	echo "default" > /data/.gabriel/.active.profile;
	PROFILE=$(cat /data/.gabriel/.active.profile);
fi;
if [ "$(cat /data/reset_gabriel_dir)" -eq "$CLEAN_GABRIEL_DIR" ]; then
	if [ "$(cat /data/.gabriel/reset_profiles)" != "$RESET_MAGIC" ]; then
		if [ ! -e /data/.gabriel_old ]; then
			mkdir /data/.gabriel_old;
		fi;
		cp -a /data/.gabriel/*.profile /data/.gabriel_old/;
		$BB rm -f /data/.gabriel/*.profile;
		if [ -e /data/data/com.af.synapse/databases ]; then
			$BB rm -R /data/data/com.af.synapse/databases;
		fi;
		echo "$RESET_MAGIC" > /data/.gabriel/reset_profiles;
	else
		echo "no need to reset profiles or delete .gabriel folder";
	fi;
else
	# Clean /data/.gabriel/ folder from all files to fix any mess but do it in smart way.
	if [ -e /data/.gabriel/"$PROFILE".profile ]; then
		cp /data/.gabriel/"$PROFILE".profile /sdcard/"$PROFILE".profile_backup;
	fi;
	if [ ! -e /data/.gabriel_old ]; then
		mkdir /data/.gabriel_old;
	fi;
	cp -a /data/.gabriel/* /data/.gabriel_old/;
	$BB rm -f /data/.gabriel/*
	if [ -e /data/data/com.af.synapse/databases ]; then
		$BB rm -R /data/data/com.af.synapse/databases;
	fi;
	echo "$CLEAN_GABRIEL_DIR" > /data/reset_gabriel_dir;
	echo "$RESET_MAGIC" > /data/.gabriel/reset_profiles;
	echo "$PROFILE" > /data/.gabriel/.active.profile;
fi;

[ ! -f /data/.gabriel/default.profile ] && cp -a /res/customconfig/default.profile /data/.gabriel/default.profile;
[ ! -f /data/.gabriel/battery.profile ] && cp -a /res/customconfig/battery.profile /data/.gabriel/battery.profile;
[ ! -f /data/.gabriel/performance.profile ] && cp -a /res/customconfig/performance.profile /data/.gabriel/performance.profile;
[ ! -f /data/.gabriel/extreme_performance.profile ] && cp -a /res/customconfig/extreme_performance.profile /data/.gabriel/extreme_performance.profile;
[ ! -f /data/.gabriel/extreme_battery.profile ] && cp -a /res/customconfig/extreme_battery.profile /data/.gabriel/extreme_battery.profile;

$BB chmod -R 0777 /data/.gabriel/;

. /res/customconfig/customconfig-helper;
read_defaults;
read_config;

# Load parameters for Synapse
DEBUG=/data/.gabriel/;
BUSYBOX_VER=$(busybox | grep "BusyBox v" | cut -c0-15);
echo "$BUSYBOX_VER" > $DEBUG/busybox_ver;

# start CORTEX by tree root, so it's will not be terminated.
sed -i "s/cortexbrain_background_process=[0-1]*/cortexbrain_background_process=1/g" /sbin/ext/cortexbrain-tune.sh;
if [ "$(pgrep -f "cortexbrain-tune.sh" | wc -l)" -eq "0" ]; then
	$BB nohup $BB sh /sbin/ext/cortexbrain-tune.sh > /data/.gabriel/cortex.txt &
fi;

OPEN_RW;

# kill charger logo binary to prevent ROM running it.
CHECK_BOOT_STATE=$(cat /proc/cmdline | grep "androidboot.mode=" | $BB wc -l);
if [ "$CHECK_BOOT_STATE" -eq "0" ]; then
	rm /sbin/chargerlogo;
fi;

# copy cron files
$BB cp -a /res/crontab/ /data/
if [ ! -e /data/crontab/custom_jobs ]; then
	$BB touch /data/crontab/custom_jobs;
	$BB chmod 777 /data/crontab/custom_jobs;
fi;

if [ "$stweaks_boot_control" == "yes" ]; then
	# apply Synapse monitor
	$BB sh /res/synapse/uci reset;
	# apply STweaks settings
	$BB sh /res/uci_boot.sh apply;
	$BB mv /res/uci_boot.sh /res/uci.sh;
else
	$BB mv /res/uci_boot.sh /res/uci.sh;
fi;

######################################
# Loading Modules
######################################
MODULES_LOAD()
{
	# order of modules load is important

	if [ "$cifs_module" == "on" ]; then
		if [ -e /system/lib/modules/cifs.ko ]; then
			$BB insmod /system/lib/modules/cifs.ko;
		else
			$BB insmod /lib/modules/cifs.ko;
		fi;
	else
		echo "no user modules loaded";
	fi;
}

# disable debugging on some modules
if [ "$logger" -ge "1" ]; then
	echo "N" > /sys/module/kernel/parameters/initcall_debug;
#	echo "0" > /sys/module/alarm/parameters/debug_mask;
#	echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
#	echo "0" > /sys/module/binder/parameters/debug_mask;
	echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask;
#	echo "0" > /sys/kernel/debug/clk/debug_suspend;
#	echo "0" > /sys/kernel/debug/msm_vidc/debug_level;
#	echo "0" > /sys/module/ipc_router/parameters/debug_mask;
#	echo "0" > /sys/module/msm_serial_hs/parameters/debug_mask;
#	echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask;
#	echo "0" > /sys/module/mpm_of/parameters/debug_mask;
#	echo "0" > /sys/module/msm_pm/parameters/debug_mask;
#	echo "0" > /sys/module/smp2p/parameters/debug_mask;
fi;

OPEN_RW;

# set horsetastic tuning.
HORSETASTIC_TUNING;

# Start any init.d scripts that may be present in the rom or added by the user
$BB chmod -R 755 /system/etc/init.d/;
if [ "$init_d" == "on" ]; then
	(
		$BB nohup $BB run-parts /system/etc/init.d/ > /data/.gabriel/init.d.txt &
	)&
else
	if [ -e /system/etc/init.d/99SuperSUDaemon ]; then
		$BB nohup $BB sh /system/etc/init.d/99SuperSUDaemon > /data/.gabriel/root.txt &
	else
		echo "no root script in init.d";
	fi;
fi;

OPEN_RW;

# Fix critical perms again after init.d mess
CRITICAL_PERM_FIX;

if [ "$stweaks_boot_control" == "yes" ]; then
	# Load Custom Modules
	MODULES_LOAD;
fi;

echo "0" > /cputemp/freq_limit_debug;

if [ "$(cat /sys/module/powersuspend/parameters/sleep_state)" -eq "0" ]; then
	$BB sh /res/uci.sh cpu0_min_freq "$cpu0_min_freq";
	$BB sh /res/uci.sh cpu1_min_freq "$cpu1_min_freq";
	$BB sh /res/uci.sh cpu2_min_freq "$cpu2_min_freq";
	$BB sh /res/uci.sh cpu3_min_freq "$cpu3_min_freq";

	$BB sh /res/uci.sh cpu0_max_freq "$cpu0_max_freq";
	$BB sh /res/uci.sh cpu1_max_freq "$cpu1_max_freq";
	$BB sh /res/uci.sh cpu2_max_freq "$cpu2_max_freq";
	$BB sh /res/uci.sh cpu3_max_freq "$cpu3_max_freq";
fi;

# tune I/O controls to boost I/O performance

#This enables the user to disable the lookup logic involved with IO
#merging requests in the block layer. By default (0) all merges are
#enabled. When set to 1 only simple one-hit merges will be tried. When
#set to 2 no merge algorithms will be tried (including one-hit or more
#complex tree/hash lookups).
if [ "$(cat /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/queue/nomerges)" != "2" ]; then
	echo "2" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/queue/nomerges;
	echo "2" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0rpmb/queue/nomerges;
fi;

#If this option is '1', the block layer will migrate request completions to the
#cpu "group" that originally submitted the request. For some workloads this
#provides a significant reduction in CPU cycles due to caching effects.
#For storage configurations that need to maximize distribution of completion
#processing setting this option to '2' forces the completion to run on the
#requesting cpu (bypassing the "group" aggregation logic).
if [ "$(cat /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/queue/rq_affinity)" != "1" ]; then
	echo "1" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/queue/rq_affinity;
	echo "1" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0rpmb/queue/rq_affinity;
fi;

(
	sleep 30;

	# Reload usb driver to open MTP and fix fast charge.
	CHARGER_STATE=$(cat /sys/class/power_supply/battery/charging_enabled);
	if [ "$CHARGER_STATE" -eq "1" ] && [ "$adb_selector" -eq "1" ]; then
		stop adbd
		sleep 1;
		start adbd
	fi;

	# stop google service and restart it on boot. this remove high cpu load and ram leak!
	if [ "$($BB pidof com.google.android.gms | wc -l)" -eq "1" ]; then
		$BB kill $($BB pidof com.google.android.gms);
	fi;
	if [ "$($BB pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
		$BB kill $($BB pidof com.google.android.gms.unstable);
	fi;
	if [ "$($BB pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
		$BB kill $($BB pidof com.google.android.gms.persistent);
	fi;
	if [ "$($BB pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
		$BB kill $($BB pidof com.google.android.gms.wearable);
	fi;

	# Google Services battery drain fixer by Alcolawl@xda
	# http://forum.xda-developers.com/google-nexus-5/general/script-google-play-services-battery-t3059585/post59563859
	pm enable com.google.android.gms/.update.SystemUpdateActivity
	pm enable com.google.android.gms/.update.SystemUpdateService
	pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
	pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
	pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
	pm enable com.google.android.gsf/.update.SystemUpdateActivity
	pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
	pm enable com.google.android.gsf/.update.SystemUpdateService
	pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
	pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver

	# stop core control if need to
	echo "$core_control" > /sys/module/msm_thermal/core_control/core_control;

	# script finish here, so let me know when
	TIME_NOW=$(date)
	echo "$TIME_NOW" > /data/boot_log_dm

	$BB mount -o remount,ro /system;
)&
