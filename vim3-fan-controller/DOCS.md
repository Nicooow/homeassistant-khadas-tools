# Home Assistant Add-on : VIM3 Fan Controller

## Configuration

**⚠️ : all temperatures are in Celsius\*1000, so 50°C is 50000.** _(Farhenheit user, good luck)_

Add-on configuration:

```json
{
  "threshold_1": 40000,
  "threshold_2": 60000,
  "threshold_3": 80000,
  "tolerance": 2500,
  "interval": 30000
}
```

### Option: `threshold_1`, `threshold_2`, `threshold_3`

Because the fan can only be controlled by three speeds, the fan will be set to the lowest speed when the CPU temperature is below `threshold_1`, to the medium speed when the CPU temperature is between `threshold_1` and `threshold_2`, and to the highest speed when the CPU temperature is above `threshold_3`.

### Option: `tolerance`

The `tolerance` option is used to avoid the fan to turn on and off too often. The fan will only change its speed if the CPU temperature has changed by more than `tolerance` since the last speed change.

Example : if the CPU temperature is 50000 and the `tolerance` is 2500, the fan will only change its speed if the CPU temperature is below 47500 or above 52500.

### Option: `interval`

The `interval` option is used to set the interval between two CPU temperature checks. (in milliseconds)
