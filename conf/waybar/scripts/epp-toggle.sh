#!/bin/bash

EPP_PATH="/sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference"
AVAILABLE_EPP_PATH="/sys/devices/system/cpu/cpufreq/policy0/energy_performance_available_preferences"

# Read the current EPP setting
current_epp=$(cat "$EPP_PATH")

# Read available options
read -r -a epp_options <<< "$(cat "$AVAILABLE_EPP_PATH")"

# Filter out 'default' from the options
epp_options=($(echo "${epp_options[@]}" | tr ' ' '\n' | grep -v '^default$' | tr '\n' ' '))

# Output available EPP options for debugging
# echo "Available EPP options (excluding 'default'): ${epp_options[@]}"
# echo "Current EPP setting: $current_epp"

# Get current index
current_index=-1
for i in "${!epp_options[@]}"; do
  if [[ "${epp_options[$i]}" == "$current_epp" ]]; then
    current_index=$i
    break
  fi
done

# Ensure current_index is valid, fallback to 0 if not found
if [[ $current_index -eq -1 ]]; then
  current_index=0
fi

# Calculate the next index and apply the next mode
next_index=$(( (current_index + 1) % ${#epp_options[@]} ))

# Output the current and next index for debugging
# echo "Current index: $current_index"
# echo "Next index: $next_index"

# Apply the next power mode if 'next' argument is provided
if [[ "$1" == "next" ]]; then
  next_epp="${epp_options[$next_index]}"

  # Apply to all CPUs
  for policy in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
    echo "$next_epp" | sudo tee "$policy" > /dev/null
  done

  sleep 0.1
  current_epp=$(cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference)

fi

# Output the current mode with corresponding icon
case "$current_epp" in
  performance) echo "Performance (⚡)" ;;
  balance_performance) echo "Balanced Performance (🎯)" ;;
  balance_power) echo "Balanced Power (⚖️)" ;;
  power) echo "Power Saver (🌿)" ;;
  *) echo "Unknown ($current_epp)" ;;
esac

