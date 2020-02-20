#!/bin/bash /etc/rc.common
. /lib/functions.sh


CUSTOM_RULE_FILE="/tmp/yaml_rule_group.yaml"
CLASH_CONFIG="/etc/clash/config.yaml"
TYPE=$(uci get clash.config.type 2>/dev/null)

 
get_rule_file()
{
   if [ -z "$1" ]; then
      return
   fi

   CUSTOM_RULE_PATH="/tmp/ip-addr.conf"
   sed '/^#/d' $CUSTOM_RULE_PATH 2>/dev/null |sed '/^ *$/d' |awk '{print "- $TYPE,"$0}' |awk -v tag="$2" '{print $0","'tag'""}' >> $CUSTOM_RULE_FILE 2>/dev/null
   set_rule_file=1
}


ip-addr_get()
{
	   local section="$1"
	   config_get "ip-addr" "$section" "ip-addr" ""
	   config_get "type" "$section" "type" ""
	   echo "$ip-addr" >>/tmp/ip-addr.conf
}

	
	
yml_rule_get()
{
   local section="$1"
   config_get "p-group" "$section" "p-group" ""

   if [ -f $CUSTOM_RULE_FILE ];then
	rm -rf $CUSTOM_RULE_FILE 2>/dev/null
   fi

   if [ -z "$p-group" ]; then
      return
   fi

   config_load clash
   config_foreach ip-addr_get "ip-addr"
   
   config_list_foreach "$section" "ip-addr" get_rule_file "$p-group"
}



config_load "clash"
config_foreach yml_rule_get "addtype"


if [ -f $CUSTOM_RULE_FILE ];then

sed -i -e "\$a#*******CUSTOM-RULE-END**********#" $CUSTOM_RULE_FILE 2>/dev/null
sed -i '/#*******CUSTOM-RULE-START**********#/,/#*******CUSTOM-RULE-END**********#/d' "$CLASH_CONFIG" 2>/dev/null

if [ ! -z "$(grep "^ \{0,\}- GEOIP" "/etc/clash/config.yaml")" ]; then
   sed -i '1,/^ \{0,\}- GEOIP,/{/^ \{0,\}- GEOIP,/s/^ \{0,\}- GEOIP,/#*******CUSTOM-RULE-START**********#\n&/}' "$CLASH_CONFIG" 2>/dev/null
elif [ ! -z "$(grep "^ \{0,\}- MATCH," "$RULE_FILE")" ]; then
   sed -i '1,/^ \{0,\}- MATCH,/{/^ \{0,\}- MATCH,/s/^ \{0,\}- MATCH,/#*******CUSTOM-RULE-START**********#\n&/}' "$CLASH_CONFIG" 2>/dev/null
else
   echo "#*******GAME RULE START**********#" >> "$CLASH_CONFIG" 2>/dev/null
fi

sed -i '/CUSTOM-RULE-START/r/tmp/yaml_rule_group.yaml' "$CLASH_CONFIG" 2>/dev/null
fi

else
sed -i '/#*******CUSTOM-RULE-START**********#/,/#*******CUSTOM-RULE-END**********#/d' "$CLASH_CONFIG" 2>/dev/null



