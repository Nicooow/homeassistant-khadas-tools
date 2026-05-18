#!/usr/bin/with-contenv bashio

mode=$(bashio::config 'mode')

bashio::log.info "VIM3 USB/PCIe Switch starting..."
bashio::log.info "Selected mode: $mode"

if [ "$mode" = "0" ]; then
  bashio::log.info "Activating: USB 3.0 enabled, PCIe disabled"
elif [ "$mode" = "1" ]; then
  bashio::log.info "Activating: PCIe enabled, USB 3.0 disabled"
else
  bashio::log.error "Invalid mode value: $mode. Accepted values are 0 or 1."
  exit 1
fi

current=$(i2cget -f -y 0 0x18 0x33 2>&1) && \
  bashio::log.info "Register USB_PCIE_SWITCH (0x18/0x33) before change: $current" || \
  bashio::log.warning "Register USB_PCIE_SWITCH (0x18/0x33) before change: read not supported (${current})"

i2cset -f -y 0 0x18 0x33 "$mode"

after=$(i2cget -f -y 0 0x18 0x33 2>&1) && \
  bashio::log.info "Register USB_PCIE_SWITCH (0x18/0x33) after change: $after" || \
  bashio::log.warning "Register USB_PCIE_SWITCH (0x18/0x33) after change: read not supported (${after})"

bashio::log.info "Command executed successfully. You can now uninstall this add-on if needed."
exit 0
