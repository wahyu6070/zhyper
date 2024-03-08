#!/system/bin/sh
#zhyper
# by wahyu6070
MODDIR=${0%/*}

sleep 50s
BASE=/sdcard/Android/zhyper
DATA=$BASE/data
LOG=$BASE/zhyper.log



mkdir -p $BASE
rm -rf $LOG

GET_LIST(){
	local NUM=$1
	local FILE=$2
	cat $FILE | tail -n 1 | tr -s ' ' | cut -d' ' -f${NUM}
	}
PUT(){
	echo $1 > $2
	if [ $? = 0 ]; then
	echo "[PUT] <$1> to <$2> [OK]" >> $LOG
	else
	echo "[PUT] <$1> to <$2> [EEROR]" >> $LOG
	fi
	}
sedlog(){
	echo "$1" >> $LOG
	}

	
if [ -f $BASE/data/mode ] && [ $(cat $BASE/data/mode) = performance ]; then
MODE=performance
elif [ -f $BASE/data/mode ] && [ $(cat $BASE/data/mode) = powersave ]; then
MODE=powersave
else
MODE=normal
fi


DATE=$(date +%Y-%m-%d-%H-%M-%S)
sedlog " Running : $DATE"
echo "MODE = $MODE" >> $LOG

#GPU
#clock
case $MODE in
performance)
#gpu
PUT performance /sys/kernel/gpu/gpu_governor
PUT $(GET_LIST 4 /sys/kernel/gpu/gpu_freq_table) /sys/kernel/gpu/gpu_min_clock
#cpu
for UY in $(ls -1 /sys/bus/cpu/devices); do
	K=/sys/bus/cpu/devices
 if [ -d $K/$UY/cpufreq ]; then
 	PUT performance $K/$UY/cpufreq/scaling_governor
 	PUT $(GET_LIST 2 $K/$UY/cpufreq/scaling_available_frequencies) $K/$UY/cpufreq/scaling_min_freq
 fi
done
#thermal
THERMALD=/sys/class/thermal
for WQ in $(ls -1 $THERMALD); do
	if [ -d $THERMALD/$WQ ]; then
		if [ -f $THERMALD/$WQ/mode ]; then
			PUT disabled $THERMALD/$WQ/mode
		fi
	fi
done


;;
powersave)
#GPU
PUT powersave /sys/kernel/gpu/gpu_governor
PUT $(GET_LIST 4 /sys/kernel/gpu/gpu_freq_table) /sys/kernel/gpu/gpu_max_clock
#CPU
for UY in $(ls -1 /sys/bus/cpu/devices); do
	K=/sys/bus/cpu/devices
 if [ -d $K/$UY/cpufreq ]; then
 	PUT powersave $K/$UY/cpufreq/scaling_governor
 	PUT $(GET_LIST 4 $K/$UY/cpufreq/scaling_available_frequencies) $K/$UY/cpufreq/scaling_max_freq
 fi
done

#thermal
THERMALD=/sys/class/thermal
for WQ in $(ls -1 $THERMALD); do
	if [ -d $THERMALD/$WQ ]; then
		if [ -f $THERMALD/$WQ/mode ]; then
			PUT enabled $THERMALD/$WQ/mode
		fi
	fi
done
;;
esac


if [ "$(getprop init.svc.logd)" = running ]; then
stop logd
fi

if [ "$(getprop init.svc.statsd)" = running ]; then
stop statsd
fi

#remove reboot file create by controller
rm -rf $DATA/reboot


