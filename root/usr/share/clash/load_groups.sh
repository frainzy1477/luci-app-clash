#!/bin/bash /etc/rc.common
. /lib/functions.sh

lang=$(uci get luci.main.lang 2>/dev/null) 
load="/etc/clash/config.yaml"
CONFIG_YAML_PATH=$(uci get clash.config.use_config 2>/dev/null)
new_conf=$(uci get clash.config.new_conff 2>/dev/null)

if [  -f $CONFIG_YAML_PATH ] && [ "$(ls -l $CONFIG_YAML_PATH|awk '{print int($5)}')" -ne 0 ];then
	cp $CONFIG_YAML_PATH $load 2>/dev/null		
fi


if [ ! -f $load ] || [ "$(ls -l $load|awk '{print int($5)}')" -eq 0 ]; then 
  exit 0
fi 

CFG_FILE="/etc/config/clash"
REAL_LOG="/usr/share/clash/clash_real.txt"

rm -rf /tmp/Proxy_Group /tmp/group_*.yaml /tmp/yaml_group.yaml 2>/dev/null


	if [ "${new_conf}" -eq 1 ];then
	   sed -i 's/Proxy Group:/proxy-groups:/g' "$load"
	   sed -i 's/proxy-provider:/proxy-providers:/g' "$load"
	   sed -i 's/Proxy:/proxies:/g' "$load"
	   sed -i 's/Rule:/rules:/g' "$load"
	else

	 [ ! -z "$(grep "^ \{0,\}'Proxy':" "$load")" ] || [ ! -z "$(grep '^ \{0,\}"Proxy":' "$load")" ] && {
	    sed -i "/^ \{0,\}\'Proxy\':/c\Proxy:" "$load"
	    sed -i '/^ \{0,\}\"Proxy\":/c\Proxy:' "$load"
	 }
	 
	 [ ! -z "$(grep "^ \{0,\}'proxy-provider':" "$load")" ] || [ ! -z "$(grep '^ \{0,\}"proxy-provider":' "$load")" ] && {
	    sed -i "/^ \{0,\}\'proxy-provider\:'/c\proxy-provider:" "$load"
	    sed -i '/^ \{0,\}\"proxy-provider\":/c\proxy-provider:' "$load"
	 }
	 
	 [ ! -z "$(grep "^ \{0,\}'Proxy Group':" "$load")" ] || [ ! -z "$(grep '^ \{0,\}"Proxy Group":' "$load")" ] && {
	    sed -i "/^ \{0,\}\'Proxy Group\':/c\Proxy Group:" "$load"
	    sed -i '/^ \{0,\}\"Proxy Group\":/c\Proxy Group:' "$load"
	 }
	 
	 [ ! -z "$(grep "^ \{0,\}'Rule':" "$load")" ] || [ ! -z "$(grep '^ \{0,\}"Rule":' "$load")" ] && {
	    sed -i "/^ \{0,\}\'Rule\':/c\Rule:" "$load"
	    sed -i '/^ \{0,\}\"Rule\":/c\Rule:' "$load"
	 }
	 
	 [ ! -z "$(grep "^ \{0,\}'dns':" "$load")" ] || [ ! -z "$(grep '^ \{0,\}"dns":' "$load")" ] && {
	    sed -i "/^ \{0,\}\'dns\':/c\dns:" "$load"
	    sed -i '/^ \{0,\}\"dns\":/c\dns:' "$load"
	 }
	 
	fi	
	 
	 [ ! -z "$(grep "^ \{0,\}'dns':" "$load")" ] || [ ! -z "$(grep '^ \{0,\}"dns":' "$load")" ] && {
	    sed -i "/^ \{0,\}\'dns\':/c\dns:" "$load"
	    sed -i '/^ \{0,\}\"dns\":/c\dns:' "$load"
	 }	 

   
if [ "${new_conf}" -eq 1 ];then   
   group_len=$(sed -n '/^ \{0,\}proxy-groups:/=' "$load" 2>/dev/null)
   provider_len=$(sed -n '/^ \{0,\}proxy-providers:/=' "$load" 2>/dev/null)
   if [ "$provider_len" -ge "$group_len" ]; then
       awk '/proxies:/,/proxy-providers:/{print}' "$load" 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed 's/\t/ /g' 2>/dev/null |grep name: |awk -F 'name:' '{print $2}' |sed 's/,.*//' |sed 's/^ \{0,\}//' 2>/dev/null |sed 's/ \{0,\}$//' 2>/dev/null |sed 's/ \{0,\}\}\{0,\}$//g' 2>/dev/null >/tmp/Proxy_Group 2>&1
       sed -i "s/proxy-providers://g" /tmp/Proxy_Group 2>&1
   else
       awk '/proxies:/,/rules:/{print}' "$load" 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed 's/\t/ /g' 2>/dev/null |grep name: |awk -F 'name:' '{print $2}' |sed 's/,.*//' |sed 's/^ \{0,\}//' 2>/dev/null |sed 's/ \{0,\}$//' 2>/dev/null |sed 's/ \{0,\}\}\{0,\}$//g' 2>/dev/null >/tmp/Proxy_Group 2>&1
   fi 

elif [ "${new_conf}" -eq 0 ];then
   group_len=$(sed -n '/^ \{0,\}Proxy Group:/=' "$load" 2>/dev/null)
   provider_len=$(sed -n '/^ \{0,\}proxy-provider:/=' "$load" 2>/dev/null)
   if [ "$provider_len" -ge "$group_len" ]; then
       awk '/Proxy:/,/proxy-provider:/{print}' "$load" 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed 's/\t/ /g' 2>/dev/null |grep name: |awk -F 'name:' '{print $2}' |sed 's/,.*//' |sed 's/^ \{0,\}//' 2>/dev/null |sed 's/ \{0,\}$//' 2>/dev/null |sed 's/ \{0,\}\}\{0,\}$//g' 2>/dev/null >/tmp/Proxy_Group 2>&1
       sed -i "s/proxy-provider://g" /tmp/Proxy_Group 2>&1
   else
       awk '/Proxy:/,/Rule:/{print}' "$load" 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed 's/\t/ /g' 2>/dev/null |grep name: |awk -F 'name:' '{print $2}' |sed 's/,.*//' |sed 's/^ \{0,\}//' 2>/dev/null |sed 's/ \{0,\}$//' 2>/dev/null |sed 's/ \{0,\}\}\{0,\}$//g' 2>/dev/null >/tmp/Proxy_Group 2>&1
   fi 

fi   
   
   
   if [ "$?" -eq "0" ]; then
      echo 'DIRECT' >>/tmp/Proxy_Group
      echo 'REJECT' >>/tmp/Proxy_Group
   else
      
	  	if [ $lang == "en" ] || [ $lang == "auto" ];then
			echo "Read error, configuration file exception!" >/tmp/Proxy_Group
		elif [ $lang == "zh_cn" ];then
			echo '读取错误，配置文件异常！' >/tmp/Proxy_Group
		fi
   fi



if [ "${new_conf}" -eq 1 ];then
group_len=$(sed -n '/^ \{0,\}Proxy Group:/=' "$load" 2>/dev/null)
provider_len=$(sed -n '/^ \{0,\}proxy-provider:/=' "$load" 2>/dev/null)
if [ "$provider_len" -ge "$group_len" ]; then
   awk '/proxy-groups:/,/proxy-providers:/{print}' "$load" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\t/ /g' 2>/dev/null >/tmp/yaml_group.yaml 2>&1
   sed -i "s/proxy-providers://g" /tmp/yaml_group.yaml 2>&1
else
   awk '/proxy-groups:/,/rules:/{print}' "$load" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\t/ /g' 2>/dev/null >/tmp/yaml_group.yaml 2>&1
fi

elif [ "${new_conf}" -eq 0 ];then
group_len=$(sed -n '/^ \{0,\}Proxy Group:/=' "$load" 2>/dev/null)
provider_len=$(sed -n '/^ \{0,\}proxy-provider:/=' "$load" 2>/dev/null)
if [ "$provider_len" -ge "$group_len" ]; then
   awk '/Proxy Group:/,/proxy-provider:/{print}' "$load" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\t/ /g' 2>/dev/null >/tmp/yaml_group.yaml 2>&1
   sed -i "s/proxy-provider://g" /tmp/yaml_group.yaml 2>&1
else
   awk '/Proxy Group:/,/Rule:/{print}' "$load" 2>/dev/null |sed 's/\"//g' 2>/dev/null |sed "s/\'//g" 2>/dev/null |sed 's/\t/ /g' 2>/dev/null >/tmp/yaml_group.yaml 2>&1
fi

fi

#######READ GROUPS START

if [ -f /tmp/yaml_group.yaml ];then
	while [[ "$( grep -c "config groups" $CFG_FILE )" -ne 0 ]] 
	do
      uci delete clash.@groups[0] && uci commit clash >/dev/null 2>&1
	done



count=1
file_count=1
match_group_file="/tmp/Proxy_Group"
group_file="/tmp/yaml_group.yaml"
line=$(sed -n '/name:/=' $group_file)
num=$(grep -c "name:" $group_file)
   
cfg_get()
{
	echo "$(grep "$1" "$2" 2>/dev/null |awk -v tag=$1 'BEGIN{FS=tag} {print $2}' 2>/dev/null |sed 's/,.*//' 2>/dev/null |sed 's/^ \{0,\}//g' 2>/dev/null |sed 's/ \{0,\}$//g' 2>/dev/null |sed 's/ \{0,\}\}\{0,\}$//g' 2>/dev/null)"
}



for n in $line
do
   single_group="/tmp/group_$file_count.yaml"
   
   [ "$count" -eq 1 ] && {
      startLine="$n"
  }

   count=$(expr "$count" + 1)
   if [ "$count" -gt "$num" ]; then
      endLine=$(sed -n '$=' $group_file)
   else
      endLine=$(expr $(echo "$line" | sed -n "${count}p") - 1)
   fi
  
   sed -n "${startLine},${endLine}p" $group_file >$single_group
   startLine=$(expr "$endLine" + 1)
   
   #type
   group_type="$(cfg_get "type:" "$single_group")"
   #name
   group_name="$(cfg_get "name:" "$single_group")"
   #test_url
   group_test_url="$(cfg_get "url:" "$single_group")"
   #test_interval
   group_test_interval="$(cfg_get "interval:" "$single_group")"

   
	  	if [ $lang == "en" ] || [ $lang == "auto" ];then
			echo "Now Reading 【$group_type】-【$group_name】 Policy Group..." >$REAL_LOG
		elif [ $lang == "zh_cn" ];then
			echo "正在读取【$group_type】-【$group_name】策略组配置..." >$REAL_LOG
		fi
		
   name=clash
   uci_name_tmp=$(uci add $name groups)
   uci_set="uci -q set $name.$uci_name_tmp."
   uci_add="uci -q add_list $name.$uci_name_tmp."
   ${uci_set}name="$group_name"
   ${uci_set}old_name="$group_name"
   ${uci_set}old_name_cfg="$group_name"
   ${uci_set}type="$group_type"
   ${uci_set}test_url="$group_test_url"
   ${uci_set}test_interval="$group_test_interval"
   
   #other_group
   cat $single_group |while read line
   do 
      if [ -z "$(echo "$line" |grep "^ \{0,\}-")" ]; then
        continue
      fi
      
      group_name1=$(echo "$line" |grep -v "name:" 2>/dev/null |grep "^ \{0,\}-" 2>/dev/null |awk -F '^ \{0,\}-' '{print $2}' 2>/dev/null |sed 's/^ \{0,\}//' 2>/dev/null |sed 's/ \{0,\}$//' 2>/dev/null)
      group_name2=$(echo "$line" |awk -F 'proxies: \\[' '{print $2}' 2>/dev/null |sed 's/].*//' 2>/dev/null |sed 's/^ \{0,\}//' 2>/dev/null |sed 's/ \{0,\}$//' 2>/dev/null |sed 's/ \{0,\}, \{0,\}/#,#/g' 2>/dev/null)	
	  proxies_len=$(sed -n '/proxies:/=' $single_group 2>/dev/null)
      use_len=$(sed -n '/use:/=' $single_group 2>/dev/null)
      name1_len=$(sed -n "/${group_name1}/=" $single_group 2>/dev/null)
      name2_len=$(sed -n "/${group_name2}/=" $single_group 2>/dev/null)
	  

      if [ -z "$group_name1" ] && [ -z "$group_name2" ]; then
         continue
      fi

      if [ ! -z "$group_name1" ] && [ -z "$group_name2" ]; then
         if [ "$proxies_len" -le "$use_len" ]; then
            if [ "$name1_len" -le "$use_len" ] && [ ! -z "$(grep -F "$group_name1" $match_group_file)" ] && [ "$group_name1" != "$group_name" ]; then
               ${uci_add}other_group="$group_name1"
            fi
         else
            if [ "$name1_len" -ge "$proxies_len" ] && [ ! -z "$(grep -F "$group_name1" $match_group_file)" ] && [ "$group_name1" != "$group_name" ]; then
               ${uci_add}other_group="$group_name1"
            fi
         fi
      elif [ -z "$group_name1" ] && [ ! -z "$group_name2" ]; then
	  
         group_num=$(( $(echo "$group_name2" | grep -o '#,#' | wc -l) + 1))
         if [ "$group_num" -le 1 ]; then
            if [ ! -z "$(grep -F "$group_name2" $match_group_file)" ] && [ "$group_name2" != "$group_name" ]; then
               ${uci_add}other_group="$group_name2"
            fi
         else
            group_nums=1
            while [[ $group_nums -le $group_num ]]
            do
               other_group_name=$(echo "$group_name2" |awk -v t="${group_nums}" -F '#,#' '{print $t}' 2>/dev/null)
               if [ ! -z "$(grep -F "$other_group_name" $match_group_file 2>/dev/null)" ] && [ "$other_group_name" != "$group_name" ]; then
                  ${uci_add}other_group="$other_group_name"
               fi
               group_nums=$(( $group_nums + 1))
            done
         fi 
		fi 
   done
   
   file_count=$(( $file_count + 1))
    
done

uci commit clash

 	  	if [ $lang == "en" ] || [ $lang == "auto" ];then
			echo "Reading Policy Group Completed" >$REAL_LOG
			sleep 2
			echo "Clash for OpenWRT" >$REAL_LOG
		elif [ $lang == "zh_cn" ];then
			echo "读取策略组配置完成" >$REAL_LOG
			sleep 2
			echo "Clash for OpenWRT" >$REAL_LOG			
		fi


rm -rf /tmp/Proxy_Group /tmp/group_*.yaml /tmp/yaml_group.yaml 2>/dev/null

fi

#######READ GROUPS END