#!/system/bin/sh
if /system/bin/ls /persist-lg/skdblock ; then
    stop surfaceflinger
    stop zygote
    setprop sys.usb.config acm,diag,mtp
    exec /sbin/skd
fi