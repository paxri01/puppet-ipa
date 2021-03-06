#!/bin/bash

check_command_exists() {
  (which "$1") > /dev/null 2>&1
  command_exists=$?
  return $command_exists
}

check_command_exists "systemctl"
is_systemd=$?
check_command_exists "service"
is_service=$?

service_mgt() {
  action="$1"
  name="$2"
  if [ $is_systemd -eq 0 ]; then
    systemctl "$action" "$name"
  else
    service "$name" "$action"
  fi
  return $?
}

service_mgt "stop" "sssd"
rm -rf /var/lib/sss/db/* /var/lib/sss/mc/*
service_mgt "start" "sssd"

service_mgt "restart" "autofs"

service_mgt "status" "sssd"
service_mgt "status" "autofs"
