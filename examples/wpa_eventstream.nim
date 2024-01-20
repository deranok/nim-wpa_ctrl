#
#
#    wpa_eventstream.nim - View wpa events on your wifi interface
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

import ../wpa_ctrl
import std/os
import std/strutils

proc main() =
  const wifi_interface = "/var/run/hostapd/wlx0057110034d6"
  var ctrl_conn = wpa_ctrl_open(wifi_interface)
  var ctrl_conn_attached: int
  var ctrl_pending_msgs: int
  
  if ctrl_conn == nil:
    echo "Could not connect to control interface"
    return
  else:
    echo "Connected to control interface"
    ctrl_conn_attached = wpa_ctrl_attach(ctrl_conn)
  
  if ctrl_conn_attached != 0:
    echo "Could not attach to control interface"
    return
  else:
    echo "Attached to control interface. Ctrl-C to stop"
    var retrieved_messages: int
    var msg_buf: array[0..4095, char]
    var msg_len: csize_t = 4096
    var msg_str = ""
    while true:
      ctrl_pending_msgs = wpa_ctrl_pending(ctrl_conn)
      if ctrl_pending_msgs > 0:
        retrieved_messages = wpa_ctrl_recv(ctrl_conn, addr msg_buf, addr msg_len)
        if retrieved_messages == 0:
          echo join(toOpenArray(msg_buf, low(msg_buf), high(msg_buf)))
          ctrl_pending_msgs = 0
      else:
        sleep(1000)
main()
