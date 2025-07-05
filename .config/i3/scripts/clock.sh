#!/bin/zsh

week=(
  "Monday"
  "Tuesday"
  "Wednesday"
  "Thursday"
  "Friday"
  "Saturday"
  "Sunday"
)

months=(
  "January"
  "February"
  "March"
  "April"
  "May"
  "June"
  "July"
  "August"
  "September"
  "October"
  "November"
  "December"
)

dayOfWeek=${week[$(date +'%u')]}
day=$(date +'%d')
month=${months[$(date +'%m')]}
year=$(date +'%Y')

echo "$dayOfWeek, $day $month $year - $(date +'%H:%m:%S')"
