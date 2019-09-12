#!/bin/bash
rule=$(uci get clash.config.rule_url 2>/dev/null)
RULE_YAML="/tmp/Rule"
CONFIG_YAML_RULE="/usr/share/clash/custom_rule.yaml"

wget --no-check-certificate --user-agent="Clash/OpenWRT"  $rule -O 2>&1 >1 $RULE_YAML


if [ -f  "$RULE_YAML" ]; then

	if [ -z  "$(grep "^ \{0,\}Rule" $RULE_YAML)" ]; then
		sed -i "1i\  " $RULE_YAML
		sed -i "2i\Rule:" $RULE_YAML
		mv $RULE_YAML $CONFIG_YAML_RULE 

	else
		sed -i "/Rule:/i\#rule" $RULE_YAML   
		sed -i "1,/\#rule/d" $RULE_YAML 
		sed -i "1i\  " $RULE_YAML
		mv $RULE_YAML $CONFIG_YAML_RULE 
	fi
fi
