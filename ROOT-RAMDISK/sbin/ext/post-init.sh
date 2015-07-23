#!/sbin/busybox sh

# Kernel Tuning by Dorimanx.

BB=/sbin/busybox

# protect init from oom
echo "-1000" > /proc/1/oom_score_adj;

OPEN_RW()
{
	$BB mount -o remount,rw /;
	$BB mount -o remount,rw /system;
}
OPEN_RW;

# run ROM scripts
$BB sh /init.qcom.post_boot.sh;

# create init.d folder if missing
if [ ! -d /system/etc/init.d ]; then
	mkdir -p /system/etc/init.d/
	$BB chmod 755 /system/etc/init.d/;
fi;

OPEN_RW;

# some nice thing for dev
if [ ! -e /cpufreq ]; then
	$BB ln -s /sys/devices/system/cpu/cpu0/cpufreq/ /cpufreq;
	$BB ln -s /sys/devices/system/cpu/cpufreq/ /cpugov;
	$BB ln -s /sys/kernel/msm_cpufreq_limit/ /msmlimit;
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
	$BB chmod 06755 /sbin/busybox
}
CRITICAL_PERM_FIX;

# this may disable mp_decision - should be disable for better control
# if you turned other HP on
stop mpdecision;

HORSTASTIC_TUNING()
{
# Set gpu settings
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
echo 2 > /sys/module/msm_hotplug/min_cpus_online
echo 2 > /sys/kernel/msm_mpdecision/conf/min_cpus
echo 1 > /sys/module/msm_hotplug/io_is_busy
# Set voltage levels
echo 725 725 725 725 735 745 755 775 785 815 825 850 895 955 990 | tee /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
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
echo nightmare | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
echo nightmare | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
echo nightmare | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3
echo nightmare | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3
# Set i/o scheduler
echo fiops | tee /sys/block/mmcblk0/queue/scheduler
echo fiops | tee /sys/block/mmcblk1/queue/scheduler
# Set cpu max speed
echo 1958400 | tee /sys/kernel/msm_cpufreq_limit/cpufreq_limit
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1958400 | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
echo 1958400 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
echo 1958400 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3
echo 1958400 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3
chmod 444 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3
# Tweak governor settings
echo 60 | tee /sys/devices/system/cpu/cpufreq/nightmare/dec_cpu_load
echo 1267200 | tee  /sys/devices/system/cpu/cpufreq/nightmare/freq_for_responsiveness
echo 1574400 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_for_responsiveness_max 
echo 10 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_step
echo 5 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_step_at_min_freq
echo 10 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_step_dec 
echo 10 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_step_dec_at_max_freq 
echo 50 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_up_brake 
echo 70 | tee /sys/devices/system/cpu/cpufreq/nightmare/freq_up_brake_at_min_freq
echo 90 | tee /sys/devices/system/cpu/cpufreq/nightmare/inc_cpu_load
echo 70 | tee /sys/devices/system/cpu/cpufreq/nightmare/inc_cpu_load_at_min_freq
echo 1 | tee /sys/devices/system/cpu/cpufreq/nightmare/io_is_busy
echo 80000 | tee /sys/devices/system/cpu/cpufreq/nightmare/sampling_rate

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
$BB chmod 666 /sys/module/msm_thermal/parameters/*
$BB chmod 666 /sys/kernel/intelli_plug/*
$BB chmod 666 /sys/class/kgsl/kgsl-3d0/max_gpuclk
$BB chmod 666 /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/governor
$BB chmod 666 /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/*_freq

# make sure our max gpu clock is set via sysfs
echo "27000000" > /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/min_freq
echo "450000000" > /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/max_freq

OPEN_RW;

# set HORSTASTIC tuning.
HORSTASTIC_TUNING;

# Turn off CORE CONTROL, to boot on all cores!
$BB chmod 666 /sys/module/msm_thermal/core_control/*
echo "0" > /sys/module/msm_thermal/core_control/enabled;

# Start any init.d scripts that may be present in the rom or added by the user
$BB chmod 755 /system/etc/init.d/*;
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

# Fix critical perms again after init.d mess
CRITICAL_PERM_FIX;

# tune I/O controls to boost I/O performance
echo "2" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/queue/nomerges;
echo "2" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0rpmb/queue/nomerges;
echo "2" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/queue/rq_affinity;
echo "2" > /sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0rpmb/queue/rq_affinity;

# script finish here, so let me know when
TIME_NOW=$(date)
echo "$TIME_NOW" > /data/boot_log_dm

$BB mount -o remount,ro /system;

(
	sleep 30;

	# Reload usb driver to open MTP and fix fast charge.
	CHARGER_STATE=$(cat /sys/class/power_supply/battery/charging_enabled);
	if [ "$CHARGER_STATE" -eq "1" ] && [ "$adb_selector" -eq "1" ]; then
		stop adbd
		echo "0" > /sys/class/android_usb/android0/enable;
		echo "633E" > /sys/class/android_usb/android0/idProduct;
		echo "mtp:mtp,acm,diag,adb" > /sys/class/android_usb/android0/functions;
		echo "1" > /sys/class/android_usb/android0/enable;
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
)&
