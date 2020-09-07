#!/usr/bin/env sh
set -e
test 0 = $#

test '' = "$(nmcli -f GENERAL.STATE con show NAT)" || nmcli connection down NAT
test '' = "$(nmcli -f GENERAL.STATE con show BridgedByEth)" || nmcli connection down BridgedByEth
test '' != "$(nmcli -f GENERAL.STATE con show BridgedByWifi)" || nmcli connection up BridgedByWifi