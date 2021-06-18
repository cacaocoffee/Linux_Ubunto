#!/bin/bash
user_name=(`ps -ef | awk '{print $1}' | grep [^UID] | sort | uniq | head -n 20`)
index=0
user_cmd=(`ps -ef | awk '{print $1,$8}' | grep ^${user_name[${index}]} | awk '{print $2}' |  head  -n 20`)
user_pid=(`ps -ef | awk '{print $1,$2}' | grep ^${user_name[${index}]} | awk '{print $2}'  | head -n 20`)
user_stime=(`ps -ef | awk '{print $1,$5}' | grep ^${user_name[${index}]} | awk '{print $2}' | head -n 20`)
nc=0	#name or cmd check
cmdindex=0


# UI 

while true  

do
# git test

user_cmd=(`ps -ef | awk '{print $1,$2,$8}' | grep ^${user_name[${index}]} | awk '{print $2,$3}'|sort -nr| awk '{print $2}' |  head  -n 20`)
user_pid=(`ps -ef | awk '{print $1,$2}' | grep ^${user_name[${index}]} | awk '{print $2}'|sort -nr| head -n 20`)
user_stime=(`ps -ef | awk '{print $1,$2,$5}' | grep ^${user_name[${index}]} | awk '{print $2,$3}'|sort -nr| awk '{print $2}' | head -n 20`)
#echo print
echo ""
echo "-NAME----------------CMD-------------------PID----STIME-----"
for ((i=0 ; i<20 ;i++))


do
        echo -n "|"
	for ((count=19-${#user_name[$i]} ;count>=0; count-=1))
        do
		if [ $index -eq $i ]; then
                	echo -n  "[41m "
		else  echo -n " "
		fi
        done
	if [ $index -eq $i ]; then
		echo -n "${user_name[$i]}[0m|"
	else  echo -n  "${user_name[$i]}|"
	fi
	
#cmd green or not
	if [ $cmdindex -eq $i ] && [ $nc -ne "0" ]; then
		echo -n "[42m"
                echo -n "${user_cmd[$i]:0:20}"
	else
		echo -n "${user_cmd[$i]:0:20}"
	fi

	for ((count=19-${#user_cmd[$i]} ;count>=0; count-=1))
        do
                echo -n  " "
        done
	echo  -n "|"
 	for ((count=6-${#user_pid[$i]};count>=0; count-=1))
        do
                echo -n " "
        done
	echo -n "${user_pid[$i]}|"
 	for ((count=7-${#user_stime[$i]};count>=0; count-=1))
        do
                echo -n " "
        done

	echo -n "${user_stime[$i]}"
	echo "[0m|" 	
done
echo "----------------------------------------------------------" 

#input data and process
	echo "If you want to exit , Please Thpe 'q' or 'Q'"
	read -t 3 -n 3  inputdata

	#q&Q
	if [ "${inputdata}" = "q" ]; then
		break
	elif [ "${inputdata}" = "Q" ]; then 
		break
	
	#right
	elif [ "${inputdata}" = "[A" ]; then
		if [ $index -gt "0" ] && [ $nc -eq "0" ]; then
			index=`expr $index - 1`
		elif [ $nc -ne "0" ] && [ $cmdindex -gt "0" ]; then
			cmdindex=`expr $cmdindex - 1`
		fi
	#left
	elif [ "${inputdata}" = "[B" ]; then
		if [ $index -lt `expr ${#user_name[@]} - 1` ] && [ $nc -eq "0" ]; then
			index=`expr $index + 1`
		elif [ $nc -ne "0" ] && [ $cmdindex -lt `expr ${#user_cmd[@]} - 1` ]; then
                        cmdindex=`expr $cmdindex + 1`	
		fi
	elif [ "${inputdata}" = "[C" ]; then
		nc=1
	elif [ "${inputdata}" = "[D" ]; then
		nc=0
		cmdindex=0
	#enter 
	elif [ "${inputdata}" = $'\0A'  ]; then
		echo "Enter input!!"
	fi
done





































































































































