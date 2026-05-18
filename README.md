# Home Assistant Khadas Tools

This repository contains a collection of add-ons for Home Assistant OS running on Khadas devices.

## Add-ons

### [Khadas VIM3 Fan Controller](./vim3-fan-controller/)

This add-on enables the fan on the VIM3, which is not enabled by default due to the missing kernel driver.

### [Khadas VIM3 USB/PCIe Switch](./vim3-usb-pcie-switch/)

This add-on lets you choose whether the M.2 slot of the Khadas VIM3 operates in **USB 3.0** mode or **PCIe** mode. It runs a single I2C command and exits — the add-on can be uninstalled afterwards.
