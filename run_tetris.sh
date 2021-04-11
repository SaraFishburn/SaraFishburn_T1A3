#!/bin/bash

bundle install

function write
{
    message="$1"

    for ((i = 0; i < ${#message}; i++)); do
      echo -n "${message:$i:1}"
      sleep 0.01
    done
}


function check_yn
{
  disable_next="$1"

  if [[ $disable_next =~ ^[Yy]$ ]]; then
    disable_next=1
  elif [[ $disable_next =~ ^[Nn]$ ]]; then
    disable_next=0
  else
    write "Your answer must be 'y' or 'n'"
    echo
    echo "(Please enter 'y' or 'n')
    "
    read disable_next
    echo
    check_yn "$disable_next"
  fi
}

clear
message_part1="
Hi there!" 
message_part2=" You're about to enter a tetris game!"
message_part3="

What level would you like to start at?"
message_part4="
(type the level number ** up to level 10 only ** and press enter)
"

write "$message_part1"
sleep 0.5
write "$message_part2"
sleep 0.5
write "$message_part3"
echo "$message_part4"

read starting_level
echo

source ./start_level.sh
no_level_entered "$starting_level"
check_if_number "$starting_level"
check_under_ten "$starting_level"

echo
write "Thanks! "
sleep 0.2
write "You will start at level $starting_level"
sleep 0.2
echo
write "Would you like to disable the 'next piece' display to make the game harder? (y/n):
"
echo
read disable_next
echo
check_yn "$disable_next"


echo
write "... Here we go!"
sleep 0.3

ruby main.rb $starting_level $disable_next