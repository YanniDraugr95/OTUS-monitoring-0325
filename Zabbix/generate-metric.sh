#!/bin/bash

metrics=("metric1" "metric2" "metric3")

declare -A metric_values

for m in "${metrics[@]}"; do
  metric_values[$m]=$((RANDOM % 101))
done

{
  echo '{'
  echo '  "data": ['
  
  for i in "${!metrics[@]}"; do
    m="${metrics[$i]}"
    v="${metric_values[$m]}"
    if [ "$i" -lt "$((${#metrics[@]} - 1))" ]; then
      printf '    {\n      "NAME": "%s",\n      "VALUE": "%s"\n    },\n' "$m" "$v"
    else
      printf '    {\n      "NAME": "%s",\n      "VALUE": "%s"\n    }\n' "$m" "$v"
    fi
  done

  echo '  ]'
  echo '}'
} > metrics.json

