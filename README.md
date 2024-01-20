wpa_wrapper
===
Thin wrapper around hostap wpa_ctrl in nim.

## Usage
By default, it is configured to use unix pipes. You can choose to use UDP instead by changing the `CONFIG_CTRL_IFACE` to `UDP`.

All the functions should work as documented in [hostap](https://w1.fi/hostapd/devel/wpa__ctrl_8h.html). 

## Example 
Edit the `wifi_interface` in the `examples/wpa_eventsstream.nim` file to point to your system's  wifi interface  and compile with `nim c examples/wpa_eventstream.nim` to see the stream of wpa events on the interface.
