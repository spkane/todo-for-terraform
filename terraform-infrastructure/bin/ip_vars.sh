#!/bin/bash

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "The script ${BASH_SOURCE[0]} is being sourced..."
  echo
else
  echo "You must source this bash script, not run it directly."
  echo
  exit 1
fi

export todo=$(terraform output  | grep todo_ips | cut -d " " -f 3)
num=0
for i in $(echo $todo | sed "s/,/ /g")
do
  all_todo_ips[${num}]=${i}
  echo "\${all_todo_ips[${num}]}: ${all_todo_ips[${num}]}"
  let num+=1
done
export todo_ip=(${all_todo_ips[0]})
echo "\${todo_ip}: ${todo_ip}"
