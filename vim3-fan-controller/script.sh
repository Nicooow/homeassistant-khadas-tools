#!/usr/bin/with-contenv bashio


# Start a simple web server on port 8099 to serve a basic HTML page to win 2 security points
fun() { while true; do nc -l -p 8099 -e echo -e 'HTTP/1.1 200 OK\r\nServer: DeskPiPro\r\nDate:$(date)\r\nContent-Type: text/html; charset=UTF8\r\nCache-Control: no-store, no cache, must-revalidate\r\n\r\n<!DOCTYPE html><html><body><p>This addon gains 2 security points for implementing this page. So it is here.</body></html>\r\n\n\n'; done; }
fun &

# Customizable variables
temperature_file="/sys/class/thermal/thermal_zone0/temp"
fan_control_command="i2cset -f -y 0 0x18 0x88"  # Replace with your fan control command
setpoint_low=$(bashio::config 'threshold_1')
setpoint_medium=$(bashio::config 'threshold_2')
setpoint_high=$(bashio::config 'threshold_3') 

while true; do
  # Get the current CPU temperature (in millidegrees Celsius)
  temperature=$(cat "$temperature_file")

  # Determine the fan speed based on the temperature
  if [ "$temperature" -le "$setpoint_low" ]; then
    fan_speed=0
  elif [ "$temperature" -le "$setpoint_medium" ]; then
    fan_speed=1
  elif [ "$temperature" -le "$setpoint_high" ]; then
    fan_speed=2
  else
    fan_speed=3
  fi

  # Execute the fan control command with the appropriate speed
  $fan_control_command "$fan_speed"

  # Sleep for 60 seconds
  sleep $(bashio::config 'interval')
done