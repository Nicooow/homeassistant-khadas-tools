# Home Assistant Add-on: VIM3 USB/PCIe Switch

This add-on lets you choose whether the M.2 slot of the Khadas VIM3 operates in **USB 3.0** mode or **PCIe** mode, by writing the appropriate value to the `USB_PCIE_SWITCH` register of the VIM3 MCU via the I2C bus.

## How it works under the hood

<!-- i2cset -f -y 0 0x33 0x01 <value> -->

The add-on runs a single bash command using `i2c-tools`:

```sh
i2cset -f -y 0 0x33 0x01 <mode>
```

Where `<mode>` is:
- `0` ? USB 3.0 enabled, PCIe disabled  
- `1` ? PCIe enabled, USB 3.0 disabled

This writes to register `USB_PCIE_SWITCH` (register byte `0x01`) of the MCU at I2C address `0x33` on bus `0`.

You can find the original documentation of the MCU I2C registers [here](https://dl.khadas.com/products/vim3/tools/mcu/vim3-mcu-reg-en.pdf).

## One-shot add-on

This add-on is **one-shot**: it runs the I2C command once and exits. Once the mode has been applied, you can **uninstall this add-on** — the configuration persists on the board.

> **Note:** A reboot of the VIM3 may be required for the change to take effect.

## Configuration

See [DOCS.md](./DOCS.md)
