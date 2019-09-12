#!/bin/bash
rule=$(uci get clash.config.rule_url 2>/dev/null)
RULE_YAML="/tmp/rule.yaml"
CONFIG_YAML_RULE="/usr/share/clash/custom_rule.yaml"
if [ -f $RULE_YAML ];then
rm -rf $RULE_YAML
fi 
wget --no-check-certificate --user-agent="Clash/OpenWRT"  $rule -O 2>&1 >1 $RULE_YAML
if [ -z $RULE_YAML ]; then
check_rule=$(grep "^ \{0,\}Rule:" $RULE_YAML |awk -F ':' '{print $1}' 2>/dev/null)
if [ -z $check_rule ]; then
sed -i "/Rule:/i\#rule" $RULE_YAML 2>/dev/null
sed -i '1,/\#rule/d' $RULE_YAML 2>/dev/null
sed -i "1i\ " $RULE_YAML
mv $RULE_YAML $CONFIG_YAML_RULE 2>/dev/null
else
sed -i "1i\ " $RULE_YAML
sed -i "2i\Rule:" $RULE_YAML
mv $RULE_YAML $CONFIG_YAML_RULE 2>/dev/null
fi
fi

