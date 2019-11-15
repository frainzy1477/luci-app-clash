#!/bin/sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="/tmp/clash.log"
MODELTYPE=$(uci get clash.config.download_core 2>/dev/null)
CORETYPE=$(uci get clash.config.core 2>/dev/null)
lang=$(uci get luci.main.lang 2>/dev/null)
enable=$(uci get clash.config.enable 2>/dev/null)

if [ $CORETYPE -eq 2 ];then
if [ -f /usr/share/clash/download_corer_version ];then
rm -rf /usr/share/clash/download_corer_version
fi
	if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - 检查更新..." >$LOG_FILE
		elif [ $lang == "en" ];then
         echo "${LOGTIME} - Checking for update.." >>$LOG_FILE
        fi
new_clashr_core_version=`wget -qO- "https://github.com/frainzy1477/clashrdev/tags"| grep "/frainzy1477/clashrdev/releases/tag/"| head -n 1| awk -F "/tag/v" '{print $2}'| sed 's/\">//'`
if [ $new_clashr_core_version ]; then
echo $new_clashr_core_version > /usr/share/clash/download_corer_version 2>&1 & >/dev/null
elif [ $new_clashr_core_version =="" ]; then
echo 0 > /usr/share/clash/download_corer_version 2>&1 & >/dev/null
fi
sleep 10
if [ -f /usr/share/clash/download_corer_version ];then
CLASHRVER=$(sed -n 1p /usr/share/clash/download_corer_version 2>/dev/null) 
fi
fi



if [ $CORETYPE -eq 1 ];then
if [ -f /usr/share/clash/download_core_version ];then
rm -rf /usr/share/clash/download_core_version
fi
	    if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - 检查更新..." >$LOG_FILE
		elif [ $lang == "en" ];then
         echo "${LOGTIME} - Checking for update.." >>$LOG_FILE
        fi
new_clashr_core_version=`wget -qO- "https://github.com/frainzy1477/clash_dev/tags"| grep "/frainzy1477/clash_dev/releases/tag/"| head -n 1| awk -F "/tag/v" '{print $2}'| sed 's/\">//'`
if [ $new_clashr_core_version ]; then
echo $new_clashr_core_version > /usr/share/clash/download_core_version 2>&1 & >/dev/null
elif [ $new_clashr_core_version =="" ]; then
echo 0 > /usr/share/clash/download_core_version 2>&1 & >/dev/null
fi
sleep 10
if [ -f /usr/share/clash/download_core_version ];then
CLASHVER=$(sed -n 1p /usr/share/clash/download_core_version 2>/dev/null) 
fi
fi

if [ -f /usr/share/clash/core_version ];then
VER=$(sed -n 1p /usr/share/clash/core_version 2>/dev/null)
else
VER=0
fi

 if [ -f /usr/share/clash/corer_version ];then
VERR=$(sed -n 1p /usr/share/clash/corer_version 2>/dev/null)
else
VERR=0
fi
 
if [ "$CLASHVER" > "$VER" ] ||  [ ! -f /etc/clash/clash ] || [ "$CLASHRVER" > "$VERR" ] || [ ! -f /usr/bin/clash ]; then

  if [ "$MODELTYPE" != 0 ]; then
   
		if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - 开始下载 Clash 内核..." >$LOG_FILE
		elif [ $lang == "en" ];then
         echo "${LOGTIME} - Starting Clash Core download" >>$LOG_FILE
        fi
		
   if [ $CORETYPE -eq 1 ];then
	wget-ssl --no-check-certificate  https://github.com/frainzy1477/clash_dev/releases/download/v"$CLASHVER"/clash-"$MODELTYPE"-v"$CLASHVER".gz -O 2>&1 >1 /tmp/clash.gz
   elif [ $CORETYPE -eq 2 ];then 
	wget-ssl --no-check-certificate  https://github.com/frainzy1477/clashrdev/releases/download/v"$CLASHRVER"/clashr-"$MODELTYPE"-v"$CLASHRVER".gz -O 2>&1 >1 /tmp/clash.gz
   fi
   
   if [ "$?" -eq "0" ] && [ "$(ls -l /tmp/clash.gz |awk '{print int($5/1024)}')" -ne 0 ]; then
     	if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - 开始解压缩文件" >$LOG_FILE
		elif [ $lang == "en" ];then 
         echo "${LOGTIME} - Beginning to gunzip file" >>$LOG_FILE
        fi
      gunzip /tmp/clash.gz >/dev/null 2>&1\
      && rm -rf /tmp/clash.gz >/dev/null 2>&1\
      && chmod 755 /tmp/clash\
      && chown root:root /tmp/clash 

	  if [ $CORETYPE -eq 1 ];then
		  if [ $lang == "zh_cn" ];then
          echo "${LOGTIME} - 完成下载内核，正在更新..." >$LOG_FILE
		  elif [ $lang == "en" ];then
	      echo "${LOGTIME} - Successfully downloaded core, updating now..." >$LOG_FILE
		  fi
		  rm -rf /etc/clash/clash\
		  && mv /tmp/clash /etc/clash/clash >/dev/null 2>&1
	  elif [ $CORETYPE -eq 2 ];then
		  if [ $lang == "zh_cn" ];then
          echo "${LOGTIME} - 完成下载内核，正在更新..." >$LOG_FILE
		  elif [ $lang == "en" ];then
	      echo "${LOGTIME} - Successfully downloaded core, updating now..." >$LOG_FILE
		  fi
		  rm -rf /usr/bin/clash\
		  && mv /tmp/clash /usr/bin/clash >/dev/null 2>&1
	  fi
      if [ "$?" -eq "0" ]; then
	    if [ $CORETYPE -eq 1 ];then
	    if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - Clash核心程序更新成功！" >LOG_FILE
		 rm -rf /usr/share/clash/core_version >/dev/null 2>&1
		 echo $CLASHVER > /usr/share/clash/core_version 2>&1 & >/dev/null
		elif [ $lang == "en" ];then
         echo "${LOGTIME} - Clash Core Update Successful" >>$LOG_FILE
		 rm -rf /usr/share/clash/core_version >/dev/null 2>&1
		 echo $CLASHVER > /usr/share/clash/core_version 2>&1 & >/dev/null
        fi
		elif [ $CORETYPE -eq 2 ];then
	    if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - Clashr核心程序更新成功！" >LOG_FILE
		 rm -rf /usr/share/clash/corer_version >/dev/null 2>&1
		 echo $CLASHRVER > /usr/share/clash/corer_version 2>&1 & >/dev/null
		elif [ $lang == "en" ];then
         echo "${LOGTIME} - Clashr Core Update Successful" >>$LOG_FILE
		 rm -rf /usr/share/clash/corer_version >/dev/null 2>&1
		 echo $CLASHRVER > /usr/share/clash/corer_version 2>&1 & >/dev/null
        fi		
		fi
		if [ $enable -eq 1 ]; then
		/etc/init.d/clash restart >/dev/null 2>&1
		fi
      else
	    if [ $lang == "zh_cn" ];then
         echo "${LOGTIME} - 核心程序更新失败，请确认设备闪存空间足够后再试！" >$LOG_FILE
		elif [ $lang == "en" ];then 
         echo "${LOGTIME} - Core Update Error" >>$LOG_FILE
        fi
      fi
   else
      if [ $lang == "zh_cn" ];then
      echo "${LOGTIME} - 核心程序下载失败，请检查网络或稍后再试！" >$LOG_FILE
	  elif [ $lang == "en" ];then     
      echo "${LOGTIME} - Core Update Error" >>$LOG_FILE
      fi
	  rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
   fi
   
   else
	 if [ $lang == "zh_cn" ];then
      echo "${LOGTIME} - 未选择编译版本，请到更新选择后再试！" >$LOG_FILE
	 elif [ $lang == "en" ];then      
       echo "${LOGTIME} - Core Type no selected，select from update page" >$LOG_FILE
	 fi 
   fi

fi
