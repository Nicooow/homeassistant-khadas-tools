# Home Assistant Add-on: VIM3 USB/PCIe Switch

## How to use

1. Set the `mode` option to the desired value (see below).
2. Start the add-on. The I2C command is sent once and the add-on exits.
3. Once applied, the configuration persists on the board — **you can safely uninstall this add-on** after the command has been executed.

> **Note:** A reboot of the VIM3 may be required for the change to take effect.

## Configuration

### Option: `mode`

| Value | Effect |
|-------|--------|
| `0` | **USB 3.0 enabled**, PCIe disabled _(default)_ |
| `1` | **PCIe enabled**, USB 3.0 disabled |

This value is written to register `USB_PCIE_SWITCH` (address `0x33`, register `0x01`) of the VIM3 MCU via the I2C bus.

You can find the original documentation of the MCU I2C registers [here](https://dl.khadas.com/products/vim3/tools/mcu/vim3-mcu-reg-en.pdf).
