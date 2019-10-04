#!/bin/sh /etc/rc.common
# functions for parsing and generating json

_json_get_var() {
	# dest=$1
	# var=$2
	eval "$1=\"\$${JSON_PREFIX}$2\""
}

_json_set_var() {
	# var=$1
	local ___val="$2"
	eval "${JSON_PREFIX}$1=\"\$___val\""
}

__jshn_raw_append() {
	# var=$1
	local value="$2"
	local sep="${3:- }"

	eval "export -- \"$1=\${$1:+\${$1}\${value:+\$sep}}\$value\""
}

_jshn_append() {
	# var=$1
	local _a_value="$2"
	eval "${JSON_PREFIX}$1=\"\${${JSON_PREFIX}$1} \$_a_value\""
}

_get_var() {
	# var=$1
	# value=$2
	eval "$1=\"\$$2\""
}

_set_var() {
	# var=$1
	local __val="$2"
	eval "$1=\"\$__val\""
}

_json_inc() {
	# var=$1
	# dest=$2

	let "${JSON_PREFIX}$1 += 1" "$2 = ${JSON_PREFIX}$1"
}

_json_add_generic() {
	# type=$1
	# name=$2
	# value=$3
	# cur=$4

	local var
	if [ "${4%%[0-9]*}" = "J_A" ]; then
		_json_inc "S_$4" var
	else
		var="${2//[^a-zA-Z0-9_]/_}"
		[[ "$var" == "$2" ]] || export -- "${JSON_PREFIX}N_${4}_${var}=$2"
	fi

	export -- \
		"${JSON_PREFIX}${4}_$var=$3" \
		"${JSON_PREFIX}T_${4}_$var=$1"
	_jshn_append "JSON_UNSET" "${4}_$var"
	_jshn_append "K_$4" "$var"
}

_json_add_table() {
	# name=$1
	# type=$2
	# itype=$3
	local cur seq

	_json_get_var cur JSON_CUR
	_json_inc JSON_SEQ seq

	local table="J_$3$seq"
	_json_set_var "U_$table" "$cur"
	export -- "${JSON_PREFIX}K_$table="
	unset "${JSON_PREFIX}S_$table"
	_json_set_var JSON_CUR "$table"
	_jshn_append "JSON_UNSET" "$table"

	_json_add_generic "$2" "$1" "$table" "$cur"
}

_json_close_table() {
	local _s_cur

	_json_get_var _s_cur JSON_CUR
	_json_get_var "${JSON_PREFIX}JSON_CUR" "U_$_s_cur"
}

json_set_namespace() {
	local _new="$1"
	local _old="$2"

	[ -n "$_old" ] && _set_var "$_old" "$JSON_PREFIX"
	JSON_PREFIX="$_new"
}

json_cleanup() {
	local unset tmp

	_json_get_var unset JSON_UNSET
	for tmp in $unset J_V; do
		unset \
			${JSON_PREFIX}U_$tmp \
			${JSON_PREFIX}K_$tmp \
			${JSON_PREFIX}S_$tmp \
			${JSON_PREFIX}T_$tmp \
			${JSON_PREFIX}N_$tmp \
			${JSON_PREFIX}$tmp
	done

	unset \
		${JSON_PREFIX}JSON_SEQ \
		${JSON_PREFIX}JSON_CUR \
		${JSON_PREFIX}JSON_UNSET
}

json_init() {
	json_cleanup
	export -n ${JSON_PREFIX}JSON_SEQ=0
	export -- \
		${JSON_PREFIX}JSON_CUR="J_V" \
		${JSON_PREFIX}K_J_V=
}

json_add_object() {
	_json_add_table "$1" object T
}

json_close_object() {
	_json_close_table
}

json_add_array() {
	_json_add_table "$1" array A
}

json_close_array() {
	_json_close_table
}

json_add_string() {
	local cur
	_json_get_var cur JSON_CUR
	_json_add_generic string "$1" "$2" "$cur"
}

json_add_int() {
	local cur
	_json_get_var cur JSON_CUR
	_json_add_generic int "$1" "$2" "$cur"
}

json_add_boolean() {
	local cur
	_json_get_var cur JSON_CUR
	_json_add_generic boolean "$1" "$2" "$cur"
}

json_add_double() {
	local cur
	_json_get_var cur JSON_CUR
	_json_add_generic double "$1" "$2" "$cur"
}

json_add_null() {
	local cur
	_json_get_var cur JSON_CUR
	_json_add_generic null "$1" "" "$cur"
}

# functions read access to json variables

json_load() {
	eval "`jshn -r "$1"`"
}

json_load_file() {
	eval "`jshn -R "$1"`"
}

json_dump() {
	jshn "$@" ${JSON_PREFIX:+-p "$JSON_PREFIX"} -w 
}

json_get_type() {
	local __dest="$1"
	local __cur

	_json_get_var __cur JSON_CUR
	local __var="${JSON_PREFIX}T_${__cur}_${2//[^a-zA-Z0-9_]/_}"
	eval "export -- \"$__dest=\${$__var}\"; [ -n \"\${$__var+x}\" ]"
}

json_get_keys() {
	local __dest="$1"
	local _tbl_cur

	if [ -n "$2" ]; then
		json_get_var _tbl_cur "$2"
	else
		_json_get_var _tbl_cur JSON_CUR
	fi
	local __var="${JSON_PREFIX}K_${_tbl_cur}"
	eval "export -- \"$__dest=\${$__var}\"; [ -n \"\${$__var+x}\" ]"
}

json_get_values() {
	local _v_dest="$1"
	local _v_keys _v_val _select=
	local _json_no_warning=1

	unset "$_v_dest"
	[ -n "$2" ] && {
		json_select "$2" || return 1
		_select=1
	}

	json_get_keys _v_keys
	set -- $_v_keys
	while [ "$#" -gt 0 ]; do
		json_get_var _v_val "$1"
		__jshn_raw_append "$_v_dest" "$_v_val"
		shift
	done
	[ -n "$_select" ] && json_select ..

	return 0
}

json_get_var() {
	local __dest="$1"
	local __cur

	_json_get_var __cur JSON_CUR
	local __var="${JSON_PREFIX}${__cur}_${2//[^a-zA-Z0-9_]/_}"
	eval "export -- \"$__dest=\${$__var:-$3}\"; [ -n \"\${$__var+x}\${3+x}\" ]"
}

json_get_vars() {
	while [ "$#" -gt 0 ]; do
		local _var="$1"; shift
		if [ "$_var" != "${_var#*:}" ]; then
			json_get_var "${_var%%:*}" "${_var%%:*}" "${_var#*:}"
		else
			json_get_var "$_var" "$_var"
		fi
	done
}

json_select() {
	local target="$1"
	local type
	local cur

	[ -z "$1" ] && {
		_json_set_var JSON_CUR "J_V"
		return 0
	}
	[[ "$1" == ".." ]] && {
		_json_get_var cur JSON_CUR
		_json_get_var cur "U_$cur"
		_json_set_var JSON_CUR "$cur"
		return 0
	}
	json_get_type type "$target"
	case "$type" in
		object|array)
			json_get_var cur "$target"
			_json_set_var JSON_CUR "$cur"
		;;
		*)
			[ -n "$_json_no_warning" ] || \
				echo "WARNING: Variable '$target' does not exist or is not an array/object"
			return 1
		;;
	esac
}

json_is_a() {
	local type

	json_get_type type "$1"
	[ "$type" = "$2" ]
}

json_for_each_item() {
	[ "$#" -ge 2 ] || return 0
	local function="$1"; shift
	local target="$1"; shift
	local type val

	json_get_type type "$target"
	case "$type" in
		object|array)
			local keys key
			json_select "$target"
			json_get_keys keys
			for key in $keys; do
				json_get_var val "$key"
				eval "$function \"\$val\" \"\$key\" \"\$@\""
			done
			json_select ..
		;;
		*)
			json_get_var val "$target"
			eval "$function \"\$val\" \"\" \"\$@\""
		;;
	esac
}

urlsafe_b64decode() {
    local d="====" data=$(echo $1 | sed 's/_/\//g; s/-/+/g')
    local mod4=$((${#data}%4))
    [ $mod4 -gt 0 ] && data=${data}${d:mod4}
    echo $data | base64 -d
}



Server_Update() {
    local uci_set="uci -q set $name.$1."
    ${uci_set}name="$ssr_remarks"
    ${uci_set}type="$ssr_type"
    ${uci_set}server="$ssr_host"
    ${uci_set}port="$ssr_port"
    uci -q get $name.@servers[$1].timeout >/dev/null || ${uci_set}timeout="60"
    ${uci_set}password="$ssr_passwd"
    ${uci_set}cipher_ssr="$ssr_method"
    ${uci_set}protocol="$ssr_protocol"
    ${uci_set}protocolparam="$ssr_protoparam"
    ${uci_set}obfs_ssr="$ssr_obfs"
    ${uci_set}obfsparam="$ssr_obfsparam"

    
	if [ "$ssr_type" = "vmess" ]; then
    #v2ray
    ${uci_set}alterId="$ssr_alter_id"
    ${uci_set}uuid="$ssr_vmess_id"
	if [ "$ssr_security" = "none" ];then
    ${uci_set}securitys="auto"
	else
	${uci_set}securitys="$ssr_security"
	fi
	if [ "$ssr_transport" = "tcp" ];then
    ${uci_set}obfs_vmess="none"
	else
	${uci_set}obfs_vmess="websocket"
	fi
    ${uci_set}custom_host="$ssr_ws_host"
    ${uci_set}path="$ssr_ws_path"
    ${uci_set}tls="$ssr_tls"
	fi
}



echo "1" >/www/lock.htm

name=clash
subscribe_url=($(uci get $name.config.subscribe_url)) 
[ ${#subscribe_url[@]} -eq 0 ] && exit 1

for ((o=0;o<${#subscribe_url[@]};o++))
do

	subscribe_data=$(wget-ssl --user-agent="User-Agent: Mozilla" --no-check-certificate -T 3 -O- ${subscribe_url[o]})
	curl_code=$?
	if [ ! $curl_code -eq 0 ];then

		subscribe_data=$(wget-ssl --no-check-certificate -T 3 -O- ${subscribe_url[o]})
		curl_code=$?
	fi
	if [ $curl_code -eq 0 ];then
		ssr_url=($(echo $subscribe_data | base64 -d | sed 's/\r//g')) 
		subscribe_max=$(echo ${ssr_url[0]} | grep -i MAX= | awk -F = '{print $2}')
		subscribe_max_x=()
			if [ -n "$subscribe_max" ]; then
				while [ ${#subscribe_max_x[@]} -ne $subscribe_max ]
				do
					if [ ${#ssr_url[@]} -ge 10 ]; then
						if [ $((${RANDOM:0:2}%2)) -eq 0 ]; then
							temp_x=${RANDOM:0:1}
						else
							temp_x=${RANDOM:0:2}
						fi
					else
						temp_x=${RANDOM:0:1}
					fi
					[ $temp_x -lt ${#ssr_url[@]} -a -z "$(echo "${subscribe_max_x[*]}" | grep -w $temp_x)" ] && subscribe_max_x[${#subscribe_max_x[@]}]="$temp_x"
				done
			else
				subscribe_max=${#ssr_url[@]}
			fi
			
			ssr_group=$(urlsafe_b64decode $(urlsafe_b64decode ${ssr_url[$((${#ssr_url[@]} - 1))]//ssr:\/\//} | sed 's/&/\n/g' | grep group= | awk -F = '{print $2}'))
			if [ -z "$ssr_group" ]; then
				ssr_group="default"
			fi
			if [ -n "$ssr_group" ]; then
				subscribe_i=0
				subscribe_n=0
				subscribe_o=0
				subscribe_x=""
				temp_host_o=()
					curr_ssr=$(uci show $name | grep @servers | grep -c server=)
					for ((x=0;x<$curr_ssr;x++)) 
					do
						temp_alias=$(uci -q get $name.@servers[$x].grouphashkey | grep "$ssr_grouphashkey")
						[ -n "$temp_alias" ] && temp_host_o[${#temp_host_o[@]}]=$(uci get $name.@servers[$x].hashkey)
					done

					for ((x=0;x<$subscribe_max;x++))
					do
						[ ${#subscribe_max_x[@]} -eq 0 ] && temp_x=$x || temp_x=${subscribe_max_x[x]}
						result=$(echo ${ssr_url[temp_x]} | grep "ssr")
						if [[ "$result" != "" ]]
						then
							temp_info=$(urlsafe_b64decode ${ssr_url[temp_x]//ssr:\/\//}) 
							
							ssr_hashkey=$(echo "$temp_info" | md5sum | cut -d ' ' -f1)


							info=${temp_info///?*/}
							temp_info_array=(${info//:/ })
							ssr_type="ssr"
							ssr_host=${temp_info_array[0]}
							ssr_port=${temp_info_array[1]}
							ssr_protocol=${temp_info_array[2]}
							ssr_method=${temp_info_array[3]}
							ssr_obfs=${temp_info_array[4]}
							ssr_passwd=$(urlsafe_b64decode ${temp_info_array[5]})
							info=${temp_info:$((${#info} + 2))}
							info=(${info//&/ })
							ssr_protoparam=""
							ssr_obfsparam=""
							ssr_remarks="$temp_x"
							for ((i=0;i<${#info[@]};i++)) 
							do
								temp_info=($(echo ${info[i]} | sed 's/=/ /g'))
								case "${temp_info[0]}" in
								protoparam)
								ssr_protoparam=$(urlsafe_b64decode ${temp_info[1]})
							;;
							obfsparam)
							ssr_obfsparam=$(urlsafe_b64decode ${temp_info[1]})
						;;
						remarks)
						ssr_remarks=$(urlsafe_b64decode ${temp_info[1]})
					;;
					esac
				done
			else
				temp_info=$(urlsafe_b64decode ${ssr_url[temp_x]//vmess:\/\//}) 
				
				ssr_hashkey=$(echo "$temp_info" | md5sum | cut -d ' ' -f1)

				ssr_type="vmess"
				json_load "$temp_info"
				json_get_var ssr_host add
				json_get_var ssr_port port
				json_get_var ssr_alter_id aid
				json_get_var ssr_vmess_id id
				json_get_var ssr_security type
				json_get_var ssr_transport net
				json_get_var ssr_remarks ps				
				json_get_var ssr_ws_host host
				json_get_var ssr_ws_path path
				json_get_var ssr_tls tls
				if [ "$ssr_tls" == "tls" -o "$ssr_tls" == "1" ]; then
					ssr_tls="true"
				else
				    ssr_tls="false"
				fi
			fi

			if [ -z "ssr_remarks" ]; then 
				ssr_remarks="$ssr_host:$ssr_port";
			fi

			uci_name_tmp=$(uci show $name | grep -w "$ssr_hashkey" | awk -F . '{print $2}')
			if [ -z "$uci_name_tmp" ]; then 
				uci_name_tmp=$(uci add $name servers)
				subscribe_n=$(($subscribe_n + 1))
			fi
			Server_Update $uci_name_tmp
			subscribe_x=$subscribe_x$ssr_hashkey" "
			ssrtype=$(echo $ssr_type | tr '[a-z]' '[A-Z]')
			
			
		done
		for ((x=0;x<${#temp_host_o[@]};x++)) 
		do
			if [ -z "$(echo "$subscribe_x" | grep -w ${temp_host_o[x]})" ]; then
				uci_name_tmp=$(uci show $name | grep ${temp_host_o[x]} | awk -F . '{print $2}')
				uci delete $name.$uci_name_tmp
				subscribe_o=$(($subscribe_o + 1))
			fi
		done
		uci commit $name
	
	fi
fi
done
echo "0" >/www/lock.htm
sh /usr/share/clash/proxy.sh 2>/dev/null
