vserver-support
===============
Stuff I use to measure vserver things
Stuff I use to get me going with namespaces
=======
Accounting SSD wear to vservers:
First we must determine the device number to name mapping:
/sys/block/<name>
/dev determines the major minor
/device -> symlink to real device . If no symlink it's no real device.
/device/model -> scsi id

filter on model or device name?

