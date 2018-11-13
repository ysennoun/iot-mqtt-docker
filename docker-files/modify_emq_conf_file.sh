#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to modify emu.conf file
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

# Check if file exists
[ ! -f /etc/emqx/emqx.conf ] && echo "File /etc/emqx/emqx.conf does not exist" && exit 1

# Configure EMQTT cluster
ip1=$(getent ahosts s1-emqtt-io | awk '{ getline; getline; print $1 }')
ip2=$(getent ahosts s2-emqtt-io | awk '{ getline; getline; print $1 }')
iphost=$(getent ahosts $(hostname) | awk '{ getline; getline; print $1 }')
echo "cluster.name = emqcl" >> /etc/emqx/emqx.conf
echo "node.name = emqcl@$(echo $iphost)" >> /etc/emqx/emqx.conf
echo "cluster.discovery = static" >> /etc/emqx/emqx.conf
echo "cluster.static.seeds = emqcl@$(echo $ip1),emqcl@$(echo $ip2)" >> /etc/emqx/emqx.conf
