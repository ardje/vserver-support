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
smsbeest:/sys/devices/pci0000:00/0000:00:1f.2# ls -al ata*/host*/targe*t*

SSD accounting needs the total write stats.
There are two write stats available:
smsbeest:/dev/cgroup/obproxy3# grep Write blkio.throttle.io_service_bytes blkio.io_service_bytes 
blkio.throttle.io_service_bytes:8:48 Write 7059456
blkio.throttle.io_service_bytes:8:0 Write 7059456
blkio.throttle.io_service_bytes:9:4 Write 7061504
blkio.io_service_bytes:8:48 Write 6750208
blkio.io_service_bytes:8:0 Write 6750208

I am not really sure what's the difference between the two and why the numbers
differ.

Modular point is: proc file parser that does something like:
read line, split line into <dev> <action> <value>
Maybe a generic parser like:
<key n+1> <key n> <value>
which returns a value, when there is a single value,
a key n -> value when there is just that, or a
key n+1->key n->value
