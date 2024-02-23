#!/system/bin/sh

MODDIR=${0%/*}

time=$(date +%Y-%m-%d-%H-%M-%S)
base=/data/media/0/Android/zhyper/log
log=$base/zhyper-logcat-${time}.txt
mkdir -p $base

echo "$time" > $log

{

logcat -f $log -v long &
sleep 50
kill %1
Loc='/data/media/0'
until [ -e ${Loc}/testx ]
   do
   sleep 1
   touch ${Loc}/testx
done
exit
} &


NUM=0
for T in $(ls -1 --sort=time $base); do
NUM=$(((NUM+1)))
if [ $NUM -eq 20 ]; then
	rm -rf $base/$T
fi
done

