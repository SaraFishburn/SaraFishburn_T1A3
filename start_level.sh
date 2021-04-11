function check_if_number
{
  starting_level="$1"

  while ! [[ "$starting_level" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; do
    echo "The starting level must be a number! Please try again:
    "
    read starting_level
    no_level_entered "$starting_level"
    check_if_number "$starting_level"
    echo
  done
}

function no_level_entered
{
  starting_level="$1"
  if [[ -z "$starting_level" ]]; then
    write "If you don't enter a starting level,"
    sleep 0.2
    write " the game will start at level 0"
    echo
    echo "(Please enter the level you would like to start at or press enter to start at level 0)"
    read starting_level
    echo
  fi

  if [[ -z "$starting_level" ]]; then
    starting_level=0
  fi
}

function check_under_ten
{
  starting_level="$1"
  if ! [[ -z "$starting_level" ]]; then
    while [ "$starting_level" -gt 10 ]; do
      write "Sorry, you can't start at a higher level than 10 :("
      echo
      echo "(Please enter a different start level)
      "
      read starting_level
      no_level_entered "$starting_level"
      check_if_number "$starting_level"
      echo
    done
  fi
}