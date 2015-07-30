#!/system/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`
battery_present=`cat /sys/class/power_supply/battery/present`
case "$target" in
    "msm7201a_ffa" | "msm7201a_surf" | "msm7627_ffa" | "msm7627_6x" | "msm7627a"  | "msm7627_surf" | \
    "qsd8250_surf" | "qsd8250_ffa" | "msm7630_surf" | "msm7630_1x" | "msm7630_fusion" | "qsd8650a_st1x")
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        ;;
esac

case "$target" in
    "msm7201a_ffa" | "msm7201a_surf")
        echo 500000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        ;;
esac

case "$target" in
    "msm7630_surf" | "msm7630_1x" | "msm7630_fusion")
        echo 75000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        echo 1 > /sys/module/pm2/parameters/idle_sleep_mode
        ;;
esac

case "$target" in
    "msm7201a_ffa" | "msm7201a_surf" | "msm7627_ffa" | "msm7627_6x" | "msm7627_surf" | "msm7630_surf" | "msm7630_1x" | "msm7630_fusion" | "msm7627a" )
        echo 245760 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        ;;
esac

case "$target" in
    "msm8660")
        echo 1 > /sys/module/rpm_resources/enable_low_power/L2_cache
        echo 1 > /sys/module/rpm_resources/enable_low_power/pxo
        echo 2 > /sys/module/rpm_resources/enable_low_power/vdd_dig
        echo 2 > /sys/module/rpm_resources/enable_low_power/vdd_mem
        echo 1 > /sys/module/rpm_resources/enable_low_power/rpm_cpu
        echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/idle_enabled
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        echo 384000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
        chown -h root.system /sys/devices/system/cpu/mfreq
        chmod -h 220 /sys/devices/system/cpu/mfreq
        chown -h root.system /sys/devices/system/cpu/cpu1/online
        chmod -h 664 /sys/devices/system/cpu/cpu1/online
        ;;
esac

case "$target" in
    "msm8960")
        echo 1 > /sys/module/rpm_resources/enable_low_power/L2_cache
        echo 1 > /sys/module/rpm_resources/enable_low_power/pxo
        echo 1 > /sys/module/rpm_resources/enable_low_power/vdd_dig
        echo 1 > /sys/module/rpm_resources/enable_low_power/vdd_mem
        echo 1 > /sys/module/pm_8x60/modes/cpu0/retention/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu2/power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu3/power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu2/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu3/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu2/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu3/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled
        echo 0 > /sys/module/msm_thermal/core_control/enabled
        echo 1 > /sys/devices/system/cpu/cpu1/online
        echo 1 > /sys/devices/system/cpu/cpu2/online
        echo 1 > /sys/devices/system/cpu/cpu3/online
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
        echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
        echo 3 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
        echo 918000 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
        echo 1026000 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
        echo 80 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
        chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        echo 384000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
        echo 384000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
        echo 384000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
        echo 1 > /sys/module/msm_thermal/core_control/enabled
        chown -h root.system /sys/devices/system/cpu/mfreq
        chmod -h 220 /sys/devices/system/cpu/mfreq
        chown -h root.system /sys/devices/system/cpu/cpu1/online
        chown -h root.system /sys/devices/system/cpu/cpu2/online
        chown -h root.system /sys/devices/system/cpu/cpu3/online
        chmod -h 664 /sys/devices/system/cpu/cpu1/online
        chmod -h 664 /sys/devices/system/cpu/cpu2/online
        chmod -h 664 /sys/devices/system/cpu/cpu3/online
        # set DCVS parameters for CPU
        echo 40000 > /sys/module/msm_dcvs/cores/cpu0/slack_time_max_us
        echo 40000 > /sys/module/msm_dcvs/cores/cpu0/slack_time_min_us
        echo 100000 > /sys/module/msm_dcvs/cores/cpu0/em_win_size_min_us
        echo 500000 > /sys/module/msm_dcvs/cores/cpu0/em_win_size_max_us
        echo 0 > /sys/module/msm_dcvs/cores/cpu0/slack_mode_dynamic
        echo 1000000 > /sys/module/msm_dcvs/cores/cpu0/disable_pc_threshold
        echo 25000 > /sys/module/msm_dcvs/cores/cpu1/slack_time_max_us
        echo 25000 > /sys/module/msm_dcvs/cores/cpu1/slack_time_min_us
        echo 100000 > /sys/module/msm_dcvs/cores/cpu1/em_win_size_min_us
        echo 500000 > /sys/module/msm_dcvs/cores/cpu1/em_win_size_max_us
        echo 0 > /sys/module/msm_dcvs/cores/cpu1/slack_mode_dynamic
        echo 1000000 > /sys/module/msm_dcvs/cores/cpu1/disable_pc_threshold
        echo 25000 > /sys/module/msm_dcvs/cores/cpu2/slack_time_max_us
        echo 25000 > /sys/module/msm_dcvs/cores/cpu2/slack_time_min_us
        echo 100000 > /sys/module/msm_dcvs/cores/cpu2/em_win_size_min_us
        echo 500000 > /sys/module/msm_dcvs/cores/cpu2/em_win_size_max_us
        echo 0 > /sys/module/msm_dcvs/cores/cpu2/slack_mode_dynamic
        echo 1000000 > /sys/module/msm_dcvs/cores/cpu2/disable_pc_threshold
        echo 25000 > /sys/module/msm_dcvs/cores/cpu3/slack_time_max_us
        echo 25000 > /sys/module/msm_dcvs/cores/cpu3/slack_time_min_us
        echo 100000 > /sys/module/msm_dcvs/cores/cpu3/em_win_size_min_us
        echo 500000 > /sys/module/msm_dcvs/cores/cpu3/em_win_size_max_us
        echo 0 > /sys/module/msm_dcvs/cores/cpu3/slack_mode_dynamic
        echo 1000000 > /sys/module/msm_dcvs/cores/cpu3/disable_pc_threshold
        # set DCVS parameters for GPU
        echo 20000 > /sys/module/msm_dcvs/cores/gpu0/slack_time_max_us
        echo 20000 > /sys/module/msm_dcvs/cores/gpu0/slack_time_min_us
        echo 0 > /sys/module/msm_dcvs/cores/gpu0/slack_mode_dynamic
        # set msm_mpdecision parameters
        echo 45000 > /sys/module/msm_mpdecision/slack_time_max_us
        echo 15000 > /sys/module/msm_mpdecision/slack_time_min_us
        echo 100000 > /sys/module/msm_mpdecision/em_win_size_min_us
        echo 1000000 > /sys/module/msm_mpdecision/em_win_size_max_us
        echo 3 > /sys/module/msm_mpdecision/online_util_pct_min
        echo 25 > /sys/module/msm_mpdecision/online_util_pct_max
        echo 97 > /sys/module/msm_mpdecision/em_max_util_pct
        echo 2 > /sys/module/msm_mpdecision/rq_avg_poll_ms
        echo 10 > /sys/module/msm_mpdecision/mp_em_rounding_point_min
        echo 85 > /sys/module/msm_mpdecision/mp_em_rounding_point_max
        echo 50 > /sys/module/msm_mpdecision/iowait_threshold_pct
        #set permissions for the nodes needed by display on/off hook
        chown -h system /sys/module/msm_dcvs/cores/cpu0/slack_time_max_us
        chown -h system /sys/module/msm_dcvs/cores/cpu0/slack_time_min_us
        chown -h system /sys/module/msm_mpdecision/slack_time_max_us
        chown -h system /sys/module/msm_mpdecision/slack_time_min_us
        chmod -h 664 /sys/module/msm_dcvs/cores/cpu0/slack_time_max_us
        chmod -h 664 /sys/module/msm_dcvs/cores/cpu0/slack_time_min_us
        chmod -h 664 /sys/module/msm_mpdecision/slack_time_max_us
        chmod -h 664 /sys/module/msm_mpdecision/slack_time_min_us
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
            "130")
                echo 230 > /sys/class/gpio/export
                echo 228 > /sys/class/gpio/export
                echo 229 > /sys/class/gpio/export
                echo "in" > /sys/class/gpio/gpio230/direction
                echo "rising" > /sys/class/gpio/gpio230/edge
                echo "in" > /sys/class/gpio/gpio228/direction
                echo "rising" > /sys/class/gpio/gpio228/edge
                echo "in" > /sys/class/gpio/gpio229/direction
                echo "rising" > /sys/class/gpio/gpio229/edge
                echo 253 > /sys/class/gpio/export
                echo 254 > /sys/class/gpio/export
                echo 257 > /sys/class/gpio/export
                echo 258 > /sys/class/gpio/export
                echo 259 > /sys/class/gpio/export
                echo "out" > /sys/class/gpio/gpio253/direction
                echo "out" > /sys/class/gpio/gpio254/direction
                echo "out" > /sys/class/gpio/gpio257/direction
                echo "out" > /sys/class/gpio/gpio258/direction
                echo "out" > /sys/class/gpio/gpio259/direction
                chown -h media /sys/class/gpio/gpio253/value
                chown -h media /sys/class/gpio/gpio254/value
                chown -h media /sys/class/gpio/gpio257/value
                chown -h media /sys/class/gpio/gpio258/value
                chown -h media /sys/class/gpio/gpio259/value
                chown -h media /sys/class/gpio/gpio253/direction
                chown -h media /sys/class/gpio/gpio254/direction
                chown -h media /sys/class/gpio/gpio257/direction
                chown -h media /sys/class/gpio/gpio258/direction
                chown -h media /sys/class/gpio/gpio259/direction
                echo 0 > /sys/module/rpm_resources/enable_low_power/vdd_dig
                echo 0 > /sys/module/rpm_resources/enable_low_power/vdd_mem
                ;;
        esac
        ;;
esac

case "$target" in
    "msm8974")
        echo 4 > /sys/module/lpm_levels/enable_low_power/l2
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
        echo 0 > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
        echo 0 > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
        echo 0 > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
        echo 0 > /sys/module/msm_pm/modes/cpu3/retention/idle_enabled
        echo 0 > /sys/module/msm_thermal/core_control/enabled
        if [ "1" == "$battery_present" ]; then
            echo 1 > /sys/devices/system/cpu/cpu1/online
            echo 1 > /sys/devices/system/cpu/cpu2/online
            echo 1 > /sys/devices/system/cpu/cpu3/online
        else
            echo 0 > /sys/devices/system/cpu/cpu1/online
            echo 0 > /sys/devices/system/cpu/cpu2/online
            echo 0 > /sys/devices/system/cpu/cpu3/online
        fi
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        if [ -f /sys/devices/f9967000.i2c/i2c-0/0-0072/enable_irq ]; then
            echo 1 > /sys/devices/f9967000.i2c/i2c-0/0-0072/enable_irq
        else
            echo "doesn't find slimport enable_irq"
        fi

        case "$soc_id" in
            "208" | "211" | "214" | "217" | "209" | "212" | "215" | "218" | "194" | "210" | "213" | "216")
                for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
                do
                    echo "cpubw_hwmon" > $devfreq_gov
                done
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
echo 730 730 730 730 740 750 760 780 790 820 830 855 900 960 995 | tee /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

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
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu1
echo 300000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu2
echo 300000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu3
echo 300000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_min_freq_cpu3

# Set cpu governor
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ondemand | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo ondemand | tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo ondemand | tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo ondemand | tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
echo ondemand | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
echo ondemand | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3
echo ondemand | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_governor_cpu3

# Set i/o scheduler
echo fiops | tee /sys/block/mmcblk0/queue/scheduler
echo fiops | tee /sys/block/mmcblk1/queue/scheduler

# Set cpu max speed
echo 2265600 | tee /sys/kernel/msm_cpufreq_limit/cpufreq_limit
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1728000 | tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo 1728000 | tee /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo 1728000 | tee /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo 2265600 | tee /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq

chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
echo 1728000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu1
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
echo 1728000 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu2
chmod 644 /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3
echo 2265600 | tee /sys/devices/system/cpu/cpufreq/all_cpus/scaling_max_freq_cpu3

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

            ;;
            *)
                echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
                echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
                echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
                echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
                echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
                echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
                echo 2 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
                echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
                echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
                echo 3 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
                echo 960000 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
                echo 960000 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
                echo 1190400 > /sys/devices/system/cpu/cpufreq/ondemand/input_boost
                echo 80 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
            ;;
        esac
        echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
        echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
        echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        echo 1 > /sys/module/msm_thermal/core_control/enabled
        chown -h root.system /sys/devices/system/cpu/mfreq
        chmod -h 220 /sys/devices/system/cpu/mfreq
        chown -h root.system /sys/devices/system/cpu/cpu1/online
        chown -h root.system /sys/devices/system/cpu/cpu2/online
        chown -h root.system /sys/devices/system/cpu/cpu3/online
        chmod -h 664 /sys/devices/system/cpu/cpu1/online
        chmod -h 664 /sys/devices/system/cpu/cpu2/online
        chmod -h 664 /sys/devices/system/cpu/cpu3/online
        echo 1 > /dev/cpuctl/apps/cpu.notify_on_migrate
    ;;
esac

case "$target" in
    "msm8226")
        echo 4 > /sys/module/lpm_levels/enable_low_power/l2
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
        echo 1 > /sys/devices/system/cpu/cpu1/online
        echo 1 > /sys/devices/system/cpu/cpu2/online
        echo 1 > /sys/devices/system/cpu/cpu3/online
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 2 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
        echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
        echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
        echo 787200 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
        echo 300000 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
        echo 80 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
        echo 787200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        chown -h root.system /sys/devices/system/cpu/cpu1/online
        chown -h root.system /sys/devices/system/cpu/cpu2/online
        chown -h root.system /sys/devices/system/cpu/cpu3/online
        chmod -h 664 /sys/devices/system/cpu/cpu1/online
        chmod -h 664 /sys/devices/system/cpu/cpu2/online
        chmod -h 664 /sys/devices/system/cpu/cpu3/online
    ;;
esac

case "$target" in
    "msm8610")
        echo 4 > /sys/module/lpm_levels/enable_low_power/l2
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
        echo 1 > /sys/devices/system/cpu/cpu1/online
        echo 1 > /sys/devices/system/cpu/cpu2/online
        echo 1 > /sys/devices/system/cpu/cpu3/online
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 2 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
        echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
        echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
        echo 787200 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
        echo 300000 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
        echo 80 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
        echo 787200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        setprop ro.qualcomm.perf.min_freq 7
        echo 1 > /sys/kernel/mm/ksm/deferred_timer
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        chown -h root.system /sys/devices/system/cpu/cpu1/online
        chown -h root.system /sys/devices/system/cpu/cpu2/online
        chown -h root.system /sys/devices/system/cpu/cpu3/online
        chmod -h 664 /sys/devices/system/cpu/cpu1/online
        chmod -h 664 /sys/devices/system/cpu/cpu2/online
        chmod -h 664 /sys/devices/system/cpu/cpu3/online
    ;;
esac

case "$target" in
    "apq8084")
        echo 4 > /sys/module/lpm_levels/enable_low_power/l2
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
        echo 1 > /sys/module/msm_pm/modes/cpu3/retention/idle_enabled
        echo 0 > /sys/module/msm_thermal/core_control/enabled
        echo 1 > /sys/devices/system/cpu/cpu1/online
        echo 1 > /sys/devices/system/cpu/cpu2/online
        echo 1 > /sys/devices/system/cpu/cpu3/online
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 2 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
        echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
        echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
        echo 1 > /sys/module/msm_thermal/core_control/enabled
        setprop ro.qualcomm.perf.cores_online 2
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        chown -h root.system /sys/devices/system/cpu/mfreq
        chmod -h 220 /sys/devices/system/cpu/mfreq
        chown -h root.system /sys/devices/system/cpu/cpu1/online
        chown -h root.system /sys/devices/system/cpu/cpu2/online
        chown -h root.system /sys/devices/system/cpu/cpu3/online
        chmod -h 664 /sys/devices/system/cpu/cpu1/online
        chmod -h 664 /sys/devices/system/cpu/cpu2/online
        chmod -h 664 /sys/devices/system/cpu/cpu3/online
    ;;
esac

case "$target" in
    "msm7627_ffa" | "msm7627_surf" | "msm7627_6x")
        echo 25000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        ;;
esac

case "$target" in
    "qsd8250_surf" | "qsd8250_ffa" | "qsd8650a_st1x")
        echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        ;;
esac

case "$target" in
    "qsd8650a_st1x")
        mount -t debugfs none /sys/kernel/debug
    ;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
        ;;
esac

case "$target" in
    "msm8960" | "msm8660" | "msm7630_surf")
        echo 10 > /sys/devices/platform/msm_sdcc.3/idle_timeout
        ;;
    "msm7627a")
        echo 10 > /sys/devices/platform/msm_sdcc.1/idle_timeout
        ;;
esac

# Post-setup services
case "$target" in
    "msm8660" | "msm8960" | "msm8226" | "msm8610")
        start mpdecision
        ;;
    "msm8974")
        if [ "1" == "$battery_present" ]; then
            start mpdecision
        fi
        echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
        ;;
    "apq8084")
        rm /data/system/default_values
        start mpdecision
        echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
        echo 512 > /sys/block/sda/bdi/read_ahead_kb
        echo 512 > /sys/block/sdb/bdi/read_ahead_kb
        echo 512 > /sys/block/sdc/bdi/read_ahead_kb
        echo 512 > /sys/block/sdd/bdi/read_ahead_kb
        echo 512 > /sys/block/sde/bdi/read_ahead_kb
        echo 512 > /sys/block/sdf/bdi/read_ahead_kb
        echo 512 > /sys/block/sdg/bdi/read_ahead_kb
        echo 512 > /sys/block/sdh/bdi/read_ahead_kb
        ;;
    "msm7627a")
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
            "127" | "128" | "129")
                start mpdecision
                ;;
        esac
        ;;
esac

# Enable Power modes and set the CPU Freq Sampling rates
case "$target" in
    "msm7627a")
        start qosmgrd
        echo 1 > /sys/module/pm2/modes/cpu0/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm2/modes/cpu1/standalone_power_collapse/idle_enabled
        echo 1 > /sys/module/pm2/modes/cpu0/standalone_power_collapse/suspend_enabled
        echo 1 > /sys/module/pm2/modes/cpu1/standalone_power_collapse/suspend_enabled
        #SuspendPC:
        echo 1 > /sys/module/pm2/modes/cpu0/power_collapse/suspend_enabled
        #IdlePC:
        echo 1 > /sys/module/pm2/modes/cpu0/power_collapse/idle_enabled
        echo 25000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        ;;
esac

# Change adj level and min_free_kbytes setting for lowmemory killer to kick in
case "$target" in
    "msm7627a")
        echo 0,1,2,4,9,12 > /sys/module/lowmemorykiller/parameters/adj
        echo 5120 > /proc/sys/vm/min_free_kbytes
        ;;
esac

# Install AdrenoTest.apk if not already installed
if [ -f /data/prebuilt/AdrenoTest.apk ]; then
    if [ ! -d /data/data/com.qualcomm.adrenotest ]; then
        pm install /data/prebuilt/AdrenoTest.apk
    fi
fi

# Install SWE_Browser.apk if not already installed
if [ -f /data/prebuilt/SWE_AndroidBrowser.apk ]; then
    if [ ! -d /data/data/com.android.swe.browser ]; then
        pm install /data/prebuilt/SWE_AndroidBrowser.apk
    fi
fi

# Change adj level and min_free_kbytes setting for lowmemory killer to kick in
case "$target" in
    "msm8660")
        start qosmgrd
        echo 0,1,2,4,9,12 > /sys/module/lowmemorykiller/parameters/adj
        echo 5120 > /proc/sys/vm/min_free_kbytes
        ;;
esac

case "$target" in
    "msm8226" | "msm8974" | "msm8610" | "apq8084" | "mpq8092" | "msm8610")
        # Let kernel know our image version/variant/crm_version
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
        ;;
esac

# 2013-10-07 ct-radio@lge.com LGP_DATA_TCPIP_NSRM [START]
targetProd=`getprop ro.product.name`
case "$targetProd" in
     "g3_kddi_jp" | "g3_lgu_kr" | "g3_skt_kr" | "tiger6_lgu_kr" | "tiger6_skt_kr")
        mkdir /data/connectivity/
        chown system.system /data/connectivity/
        chmod 775 /data/connectivity/
        mkdir /data/connectivity/nsrm/
        chown system.system /data/connectivity/nsrm/
        chmod 775 /data/connectivity/nsrm/
        cp /system/etc/dpm/nsrm/NsrmConfiguration.xml /data/connectivity/nsrm/
        chown system.system /data/connectivity/nsrm/NsrmConfiguration.xml
        chmod 775 /data/connectivity/nsrm/NsrmConfiguration.xml
        ;;
esac
# 2013-10-07 ct-radio@lge.com LGP_DATA_TCPIP_NSRM [END]

if [ -d /system/etc/init.d ]; then
    run-parts /system/etc/init.d/
fi
