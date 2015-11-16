#!/sbin/sh

set -e

fd=$2
zip=$3

ui_print() {
	echo "ui_print $1" >> /proc/self/fd/$fd
}


rm -Rf /tmp/superuser
mkdir -p /tmp/superuser
unzip -o $3 -d /tmp/superuser/
cd /tmp/superuser/scripts/su/
bootimg="$(grep -F /boot /etc/recovery.fstab |grep -oE '/dev/[a-zA-Z0-9_./-]*')"
if [ -z "$bootimg" ];then
	ui_print "Couldn't find boot.img partition"
	exit 1
fi

ui_print "Found bootimg @ $bootimg"
sh -x ../bootimg.sh $bootimg eng
ui_print "Generated $pwd/new-boot.img"
dd if=new-boot.img of=$bootimg bs=8192
ui_print "Flashed root-ed boot.img"