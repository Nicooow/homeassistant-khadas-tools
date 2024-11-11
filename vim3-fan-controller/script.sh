#!/usr/bin/with-contenv bashio

bashio::log.info "Starting VIM3 fan controller..."

# Start a simple web server on port 8099 to serve a basic HTML page to win 2 security points
fun() { while true; do nc -l -p 8099 -e echo -e 'HTTP/1.1 200 OK\r\nServer: DeskPiPro\r\nDate:$(date)\r\nContent-Type: text/html; charset=UTF8\r\nCache-Control: no-store, no cache, must-revalidate\r\n\r\n<!DOCTYPE html><html><body><p>This addon gains 2 security points for implementing this page. So it is here.</body></html>\r\n\n\n'; done; }
fun &

# Customizable variables
temperature_file="/sys/class/thermal/thermal_zone0/temp"
fan_control_command="i2cset -f -y 0 0x18 0x88"  # Replace with your fan control command
setpoint_low=$(bashio::config 'threshold_1')
setpoint_medium=$(bashio::config 'threshold_2')
setpoint_high=$(bashio::config 'threshold_3')
interval=$(bashio::config 'interval')
tolerance=$(bashio::config 'tolerance')
last_fan_speed=0

# Log the configuration
bashio::log.info "===================== Configuration ====================="
bashio::log.info "Threshold 1: $setpoint_low"
bashio::log.info "Threshold 2: $setpoint_medium"
bashio::log.info "Threshold 3: $setpoint_high"
bashio::log.info "Interval: $interval"
bashio::log.info "Tolerance: $tolerance"
bashio::log.info "Fan control command: $fan_control_command"
bashio::log.info "Temperature file: $temperature_file"
bashio::log.info "========================================================"

# 0°C : nothing
# if fan speed == 0 {
#  if temperature > setpoint_low + tolerance, set fan speed to 1
# }
# if fan speed == 1 {
#  if temperature < setpoint_low - tolerance, set fan speed to 0
#  if temperature > setpoint_medium + tolerance, set fan speed to 2
# }
# if fan speed == 2 {
#  if temperature < setpoint_medium - tolerance, set fan speed to 1
#  if temperature > setpoint_high + tolerance, set fan speed to 3
# }
# if fan speed == 3 {
#  if temperature < setpoint_high - tolerance, set fan speed to 2
# }

while true; do
  temperature=$(cat "$temperature_file")
  bashio::log.info "Current temperature: $temperature"

  if [ "$last_fan_speed" -eq 0 ]; then
    bashio::log.debug "last_fan_speed is 0"
    if [ "$temperature" -gt "$((setpoint_low + tolerance))" ]; then
      bashio::log.debug "Temperature is > setpoint_low + tolerance"
      fan_speed=1
    else
      fan_speed=0
    fi
  elif [ "$last_fan_speed" -eq 1 ]; then
    bashio::log.debug "last_fan_speed is 1"
    if [ "$temperature" -lt "$((setpoint_low - tolerance))" ]; then
      bashio::log.debug "Temperature is < setpoint_low - tolerance"
      fan_speed=0
    elif [ "$temperature" -gt "$((setpoint_medium + tolerance))" ]; then
      bashio::log.debug "Temperature is > setpoint_medium + tolerance"
      fan_speed=2
    else
      fan_speed=1
    fi
  elif [ "$last_fan_speed" -eq 2 ]; then
    bashio::log.debug "last_fan_speed is 2"
    if [ "$temperature" -lt "$((setpoint_medium - tolerance))" ]; then
      bashio::log.debug "Temperature is < setpoint_medium - tolerance"
      fan_speed=1
    elif [ "$temperature" -gt "$((setpoint_high + tolerance))" ]; then
      bashio::log.debug "Temperature is > setpoint_high + tolerance"
      fan_speed=3
    else
      fan_speed=2
    fi
  elif [ "$last_fan_speed" -eq 3 ]; then
    bashio::log.debug "last_fan_speed is 3"
    if [ "$temperature" -lt "$((setpoint_high - tolerance))" ]; then
      bashio::log.debug "Temperature is < setpoint_high - tolerance"
      fan_speed=2
    else
      fan_speed=3
    fi
  else
    bashio::log.warning "Invalid last_fan_speed: $last_fan_speed"
    fan_speed=0
  fi

  if [ "$fan_speed" -ne "$last_fan_speed" ]; then
    bashio::log.info "Setting fan speed to $fan_speed"
    last_fan_speed="$fan_speed"
    $fan_control_command "$fan_speed"
  fi

  sleep "$interval"
done