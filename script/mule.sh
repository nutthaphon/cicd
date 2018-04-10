#!/usr/bin/ksh

MULE_HOME=/app/mulesoft/$2
MULE_APPS_HOME=$MULE_HOME/apps
MULE_LOGS_HOME=$MULE_HOME/logs
MULE_DOMAINS_HOME=$MULE_HOME/domains

ITERATION=12
SLEEP=5

cd $MULE_HOME
bin/mule $1

Start_Progression() {

	cd $MULE_APPS_HOME
	no_proc_all=`ls | cut -d. -f 1 | sed 's/-anchor$//g' | uniq | wc -l`
	no_proc_started=`ls *-anchor.txt 2>/dev/null | wc -l`
	
	echo $no_proc_all apps are there.
	while  [ $no_proc_started -gt 0 ]; do
		no_proc_started=`ls *-anchor.txt 2>/dev/null | wc -l`
	done
	
	echo "Deploying apps..."
	
	while  [ $no_proc -lt $no_proc_all ]; do
		
		if [ $no_wait -eq $ITERATION ]; then
			echo "Time out!"; 
			break; 
		fi	
		
		no_proc=`ls *-anchor.txt 2>/dev/null | wc -l`
		
		echo Debug Info: no_prev=$no_prev, no_wait=$no_wait, no_proc_all=$no_proc_all, no_proc=$no_proc, no_diff=$no_diff
		echo "----------------------------------------------------"

		if [ $no_proc -gt $no_prev ]; then
			no_diff=`expr $no_proc - $no_prev`
			ls -tr *-anchor.txt | tail -$no_diff
			echo "-----------------------------------------> deployed."		
			no_prev=$no_proc
			no_wait=0		
		elif [ $no_proc -eq 0 ]; then
			echo "Wait for first apps deploy..."
		else		
			echo "Deploying..."
			no_wait=`expr $no_wait + 1`							
		fi
		echo "####################################################"
		sleep $SLEEP
	done;

}

case "$1" in
	'start'|'restart')

		echo "Starting JVM..."
		
		no_prev=0
		no_wait=0
		no_diff=0
		no_proc=0
		
		Start_Progression
		
		echo "####################################################"
		echo "############### Finish Deployment. #################"
		echo "####################################################"
		
		tail -100 $MULE_LOGS_HOME/mule_ee.log
		
		if [ $no_wait -eq $ITERATION ]; then exit 1; fi
		
		;;
	*)	
		;;
esac