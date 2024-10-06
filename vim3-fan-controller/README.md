# Home Assistant Add-on : VIM3 Fan Controller

Because the fan is not enabled by default on the VIM3 due to the missing kernel driver, this add-on enables the fan on the VIM3 related to three CPU temperature thresholds.

_We are talking about the [3705 Cooling Fan](https://www.khadas.com/product-page/3705-cooling-fan) here._

## Configuration

see [DOCS.md](./DOCS.md)

## How it works under the hood

<!-- i2cset -f -y 0 0x18 0x88 -->

This add-on is a simple bash script which use i2c-tools to communicate with the fan controller through the MCU i2c bus.

You can find the original documentation of the MCU i2c registers [here](https://dl.khadas.com/products/vim3/mcu/vim3_mcu_reg_en.pdf).

You just have to write the fan speed to the register `0x88` of the i2c device `0x18` to change the fan speed.
