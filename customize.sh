# LiteGapps controller
# By wahyu6070

BASE=/data/media/0/Android/zhyper
BIN=$MODPATH/bin
chmod 755 $MODPATH/bin/litegapps-functions
#litegapps functions
. $MODPATH/bin/litegapps-functions

# main path
INITIAL install



[ -d $BASE ] && rm -rf $BASE && mkdir -p $BASE || mkdir -p $BASE
print "- Installing files"
cdir $BASE/files
cp -af $MODPATH/script/* $BASE/files/


ADS https://payoffyes.com/b9p0mwvwgs?key=c882ea866d79e457f018e720ee79a171


chmod -R 755 $BASE
#set perm bin
chmod -R 755 $BIN

cdir $BASE/xbin
cdir $MODPATH/system/xbin
for BBY in $($BIN/busybox --list); do
if [ ! -f $SYSTEM/bin/$BBY ]; then
print "+ Linking $BBY"
ln -sf $BIN/busybox $MODPATH/system/xbin/$BBY
fi
done


cdir $MODPATH/system/bin
cp -rdf $BIN/* $MODPATH/system/bin/


#copy binary
cp -pf $MODPATH/bin/zhyper $MODPATH/system/bin/

if [ -f /data/adb/magisk/magiskboot ]; then
	cp -pf /data/adb/magisk/magiskboot $MODPATH/system/bin/
	chmod 755 $MODPATH/system/bin/magiskboot
fi

if [ -f /data/adb/magisk/magiskboot ]; then
print "- Magiskboot detected"
print "- Installing magiskboot"
cp -pf /data/adb/magisk/magiskboot $MODPATH/system/bin/magiskboot
chmod 755 $MODPATH/system/bin/magiskboot
fi

# htop
mktouch $MODPATH/system/etc/htop/htoprc

#permissions
chmod -R 755 $MODPATH/system/bin

cp -f $MODPATH/bin/a.sh /data/adb/post-fs-data.d/zhyper.sh
chmod 755 /data/adb/post-fs-data.d/zhyper.sh

cp -f $MODPATH/bin/b.sh /data/adb/service.d/zhyper.sh
chmod 755 /data/adb/service.d/zhyper.sh

LIST_TMP="
$MODPATH/curl
$MODPATH/bin
$MODPATH/script
$MODPATH/addon
$MODPATH/litegapps_controller
"
print "- Clean cache"
for F in $LIST_TMP; do
	rm -rf $F
done


ADS https://payoffyes.com/fbz37smn33?key=a6ae3c4640a1737a2a572d122c10794c


print
print "*Tips"
print
print "- Open Terminal"
print
print "~$ su -c zhyper"
print
print