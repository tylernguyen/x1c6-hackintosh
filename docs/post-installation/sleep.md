- Disable Power Nap for both [`Battery`](https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/assets/macOS%20Settings/Battery_powernap.png) and [`Power Adapter`](https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/assets/macOS%20Settings/Poweradt_powernap.png).
- Disable [`Wake for Network Access`](https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/assets/macOS%20Settings/Poweradt_powernap.png) in `Power Adapter`.

- Uncheck `Allow Bluetooth devices to wake this computer` if you do not need it.

<p align="center">
  <img src="https://raw.githubusercontent.com/tylernguyen/x1c6-hackintosh/main/docs/img/bluetooth.png" width="400">
</p>

- Do not disable `hibernatefile`.
- `sudo pmset -a tcpkeepalive 0` to disable Network while sleeping.
- `sudo pmset -a proximitywake 0` to disable peripheral wake agent.