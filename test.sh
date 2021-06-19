#!/bin/bash
user_name=(`ps -ef | awk '{print $1}' | grep [^UID] | sort | uniq | head -n 20`)
index=0
user_cmd=(`ps -ef | awk '{print $1,$8}' | grep ^${user_name[${index}]} | awk '{print $2}' |  head  -n 20`)
user_pid=(`ps -ef | awk '{print $1,$2}' | grep ^${user_name[${index}]} | awk '{print $2}'  | head -n 20`)
user_stime=(`ps -ef | awk '{print $1,$5}' | grep ^${user_name[${index}]} | awk '{print $2}' | head -n 20`)
nc=0	#name or cmd check
cmdindex=0

#processindex_end
PIE=20

upcheck=0
downcheck=0

# UI 

while true  

do
user_cmd=(`ps -ef | awk '{print $1,$2,$8}' | grep ^${user_name[${index}]} | awk '{print $2,$3}'|sort -nr| awk '{print $2}' |head -n $PIE | tail -n 20`)
user_pid=(`ps -ef | awk '{print $1,$2}' | grep ^${user_name[${index}]} | awk '{print $2}'|sort -nr| head -n $PIE | tail -n 20`)
user_stime=(`ps -ef | awk '{print $1,$2,$5}' | grep ^${user_name[${index}]} | awk '{print $2,$3}'|sort -nr| awk '{print $2}' | head -n $PIE | tail -n 20`)
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
# user fore back ground 
	if [ $cmdindex -eq $i ] && [ $nc -ne "0" ]; then
		echo -n "[42m"
		if [ $i -lt `expr ${#user_cmd[@]} ` ]; then
                        user_FB=(`ps -uaxw | awk '{print $1,$8,$11}' | grep ^${user_name[${index}]} | awk '{print $2,$3}'| grep ${user_cmd[$i]}|awk '{print $1}' `)
                        if [[ $user_FB =~ "+" ]]; then
                                echo -n  "F "
                        else
                                echo -n  "B " 
                        fi
                fi
		echo -n "${user_cmd[$i]:0:18}"
	else
		if [ $i -lt `expr ${#user_cmd[@]} `  ]; then
			user_FB=(`ps -uaxw | awk '{print $1,$8,$11}' | grep ^${user_name[${index}]} | awk '{print $2,$3}'| grep ${user_cmd[$i]}|awk '{print $1}' `)
			if [[ $user_FB =~ "+" ]]; then
                        	echo -n  "F "
                	else
                        	echo -n  "B " 
                	fi
		fi
		echo -n "${user_cmd[$i]:0:18}"
	fi
	#spacing CMD
	if [ $i -lt `expr ${#user_cmd[@]} `  ]; then
	for ((count=17-${#user_cmd[$i]} ;count>=0; count-=1))
        do
                echo -n  " "
        done
	echo  -n "|"
	else
	for ((count=19-${#user_cmd[$i]} ;count>=0; count-=1))
        do
                echo -n  " "
        done
        echo  -n "|"
	fi

	#spacing PID
 	for ((count=6-${#user_pid[$i]};count>=0; count-=1))
        do
                echo -n " "
        done
	echo -n "${user_pid[$i]}|"
 	
	#spacing STIME
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
	
	#up
	elif [ "${inputdata}" = "[A" ]; then
		downcheck=0
		
		if [ $index -gt "0" ] && [ $nc -eq "0" ]; then
			index=`expr $index - 1`
		elif [ $nc -ne "0" ] && [ $cmdindex -gt "0" ]; then
			cmdindex=`expr $cmdindex - 1`
		fi
		#scroll up
		if [ $nc -ne "0" ] && [ $cmdindex -eq "0" ] && [ $PIE -gt "20" ]; then
			
			upcheck=1
			if [ $upcheck -eq "1" ]; then
				PIE=`expr $PIE - 1`	
			fi		
		fi
	#down
	elif [ "${inputdata}" = "[B" ]; then
		upcheck=0
		if [ $index -lt `expr ${#user_name[@]} - 1` ] && [ $nc -eq "0" ]; then
			index=`expr $index + 1`
		elif [ $nc -ne "0" ] && [ $cmdindex -lt `expr ${#user_cmd[@]} - 1` ]; then
                        cmdindex=`expr $cmdindex + 1`	
		fi
		#scroll down
		if [ $nc -ne "0" ] && [ $cmdindex -eq "19"  ]; then
			downcheck=1
			if [ $downcheck -eq "1" ]; then
				PIE=`expr $PIE + 1 `
			fi
		fi
		
	#right
	elif [ "${inputdata}" = "[C" ]; then
		nc=1
	#left
	elif [ "${inputdata}" = "[D" ]; then
		nc=0
		cmdindex=0
		PIE=20
		upcheck=0
		downcheck=0
	#enter 
	elif [ "${inputdata}" = $'\0A'  ]; then
		who=`whoami`
		if [ "$who" == "${user_name[$index]}" ] && [ $nc -ne '0' ]; then
			kill -9 "${user_pid[$cmdindex]}"
		elif [ $nc -ne '0' ]; then
			echo "You don't have premission"
		fi
	
	fi
done





































































































































