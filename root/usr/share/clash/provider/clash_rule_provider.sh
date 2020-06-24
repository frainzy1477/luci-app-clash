#!/bin/bash /etc/rc.common
. /lib/functions.sh

   RULE_FILE_NAME="$1" 
   RULE_FILE_ENNAME=$(grep -F $RULE_FILE_NAME /usr/share/clash/provider/ruleproviders/rule_provider.list |awk -F ',' '{print $4}' 2>/dev/null)
   
   if [ ! -z "$RULE_FILE_ENNAME" ]; then
      DOWNLOAD_PATH=$(grep -F ",$RULE_FILE_NAME" /usr/share/clash/provider/ruleproviders/rule_provider.list |awk -F ',' '{print $3$4}' 2>/dev/null)
   else
      DOWNLOAD_PATH=$(grep -F $RULE_FILE_NAME /usr/share/clash/provider/ruleproviders/rule_provider.list |awk -F ',' '{print $3$4}' 2>/dev/null)
   fi
   
   RULE_FILE_DIR="/etc/clash/ruleprovider/$RULE_FILE_NAME"
   TMP_RULE_DIR="/tmp/$RULE_FILE_NAME"
   LOG_FILE="/usr/share/clash/clash.txt"
   REAL_LOG="/usr/share/clash/clash_real.txt"
   
   url="https://raw.githubusercontent.com/$DOWNLOAD_PATH"
   behavior=$(grep -F $RULE_FILE_NAME /usr/share/clash/provider/ruleproviders/rule_provider.list |awk -F ',' '{print $2}' 2>/dev/null)
   name=$RULE_FILE_NAME
   path="./ruleprovider/"$RULE_FILE_NAME""
   
	if [ $lang == "en" ] || [ $lang == "auto" ];then
				echo "Updating 【$RULE_FILE_NAME】 Rule..." >$REAL_LOG
	elif [ $lang == "zh_cn" ];then
				echo "开始下载【$RULE_FILE_NAME】规则..." >$REAL_LOG
	fi 
	
   wget --no-check-certificate -c4 https://raw.githubusercontent.com/"$DOWNLOAD_PATH" -O 2>&1 >1 "$TMP_RULE_DIR"
   
   if [ "$?" -eq "0" ] && [ "$(ls -l $TMP_RULE_DIR |awk '{print $5}')" -ne 0 ]; then
   
	if [ $lang == "en" ] || [ $lang == "auto" ];then
				echo "【$RULE_FILE_NAME】 Downloaded successfully. Checking whether the rule version is updated.." >$REAL_LOG
	elif [ $lang == "zh_cn" ];then
				echo "【$RULE_FILE_NAME】规则下载成功，检查规则版本是否更新..." >$REAL_LOG
	fi
	
      cmp -s $TMP_RULE_DIR $RULE_FILE_DIR
         if [ "$?" -ne "0" ]; then
			
			if [ $lang == "en" ] || [ $lang == "auto" ];then
						echo "Rule version has been updated. Start to replace the old rule version.." >$REAL_LOG
			elif [ $lang == "zh_cn" ];then
						echo "规则版本有更新，开始替换旧规则版本..." >$REAL_LOG
			fi				
            mv $TMP_RULE_DIR $RULE_FILE_DIR >/dev/null 2>&1
			
			if [ $lang == "en" ] || [ $lang == "auto" ];then
						echo "Delete download cache" >$REAL_LOG
			elif [ $lang == "zh_cn" ];then
						echo "删除下载缓存..." >$REAL_LOG
			fi  

            rm -rf $TMP_RULE_DIR >/dev/null 2>&1
			
			if [ $lang == "en" ] || [ $lang == "auto" ];then
						echo "Rule File 【$RULE_FILE_NAME】 Download Successful" >$REAL_LOG
			elif [ $lang == "zh_cn" ];then
						echo "【$RULE_FILE_NAME】规则更新成功！" >$REAL_LOG
			fi 
			   name=clash
			   uci_name_tmp=$(uci add $name ruleprovider)
			   uci_set="uci -q set $name.$uci_name_tmp."
			   uci_add="uci -q add_list $name.$uci_name_tmp."
			   ${uci_set}type="http"   
			   ${uci_set}name="$name"
			   ${uci_set}path="$path"
			   ${uci_set}behavior="$behavior"
			   ${uci_set}url="$url"
			   ${uci_set}interval="86400"
			   uci commit clash			
		    sleep 2
			echo "Clash for OpenWRT" >$REAL_LOG
			return 1
         else
			if [ $lang == "en" ] || [ $lang == "auto" ];then
						echo "Updated Rule File 【$RULE_FILE_NAME】 No Change, Do Nothing" >$REAL_LOG
			elif [ $lang == "zh_cn" ];then
						echo "【$RULE_FILE_NAME】规则版本没有更新，停止继续操作..." >$REAL_LOG
			fi 
	
            rm -rf $TMP_RULE_DIR >/dev/null 2>&1
			sleep 2
			echo "Clash for OpenWRT" >$REAL_LOG
			return 2
         fi
   else
			if [ $lang == "en" ] || [ $lang == "auto" ];then
						echo "Rule File 【$RULE_FILE_NAME】 Download Error" >$REAL_LOG
			elif [ $lang == "zh_cn" ];then
						echo "【$RULE_FILE_NAME】规则下载失败，请检查网络或稍后再试！" >$REAL_LOG
			fi 
			rm -rf $TMP_RULE_DIR >/dev/null 2>&1	  
			sleep 2
			echo "Clash for OpenWRT" >$REAL_LOG
			return 0
   fi

