#
#
#    wpa_ctrl.nim - A thin wrapper around wpa_ctrl for nim
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

import posix
{.passc: "-I lib/hostap/src/ -I lib/hostap/src/common -I lib/hostap/src/utils".}

when defined(windows):
  {.compile: "lib/hostap/src/utils/os_win32.c".}

when defined(unix):
  {.compile: "lib/hostap/src/utils/os_unix.c"}

{.passc: "-DCONFIG_CTRL_IFACE".}
const CONFIG_CTRL_IFACE {.strdefine.}: string = "UNIX"

when (CONFIG_CTRL_IFACE == "UNIX") or (CONFIG_CTRL_IFACE == "UDP"):
  const CTRL_IFACE_SOCKET {.booldefine.}: bool = true
  {.passc: "-DCTRL_IFACE_SOCKET".}

when CONFIG_CTRL_IFACE == "UDP":
  {.passc: "-DCONFIG_CTRL_IFACE_UDP".}
  {.compile: "lib/hostap/src/utils/common.c".}
  {.compile: "lib/hostap/src/utils/wpa_debug.c".}

when CONFIG_CTRL_IFACE == "UNIX":
  {.passc: "-DCONFIG_CTRL_IFACE_UNIX".}

type
  wpa_ctrl = object
    when CONFIG_CTRL_IFACE == "UDP":
      s: int
      local: Sockaddr_in
      dest: Sockaddr_in
      cookie: cstring
      remote_ifname: cstring
      remote_ip: cstring
    
    when CONFIG_CTRL_IFACE == "UNIX":
      s: int
      local: Sockaddr_un
      dest: Sockaddr_un

{.compile: "lib/hostap/src/common/wpa_ctrl.c".}

proc wpa_ctrl_open*(ctrl_path: cstring): ptr wpa_ctrl{.importc.}
proc wpa_ctrl_open2*(ctrl_path: cstring; cli_path: cstring): ptr wpa_ctrl {.importc.}
proc wpa_ctrl_close*(ctrl: ptr wpa_ctrl) {.importc.}
proc wpa_ctrl_request*(ctrl: ptr wpa_ctrl; cmd: cstring; cmd_len: csize_t;
                      reply: cstring; reply_len: ptr csize_t;
                      msg_cb: proc (msg: cstring; len: csize_t)): cint {.importc.}
proc wpa_ctrl_attach*(ctrl: ptr wpa_ctrl): cint {.importc.}
proc wpa_ctrl_detach*(ctrl: ptr wpa_ctrl): cint {.importc.}
proc wpa_ctrl_recv*(ctrl: ptr wpa_ctrl; reply: ptr; reply_len: ptr csize_t): cint {.importc.}
proc wpa_ctrl_pending*(ctrl: ptr wpa_ctrl): cint {.importc.}
proc wpa_ctrl_get_fd*(ctrl: ptr wpa_ctrl): cint {.importc.}

