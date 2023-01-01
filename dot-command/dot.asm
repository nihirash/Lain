    device ZXSPECTRUM48
    org #2000

    include "modules/version.asm"
    jp start
ver db "Lain SNA v. ", VERSION_STRING, 13
    db "(c) 2022 Alex Nihirash", 13, 13, 0

    include "modules/display.asm"
    include "modules/wifi.asm"
    include "modules/esxdos.asm"
    include "drivers/zxuno.asm"
start:
    printMsg ver
    call EsxDOS.prepareFile
    call Uart.init
    call Wifi.init
    printMsg msg_my_ip
    printMsg Wifi.ipAddr
    printMsg new_line
    di
    jp Wifi.recv
msg_my_ip db "Device IP: ", 0
new_line db 13, "Listening port: 6144", 13, 0

buffer = #8000

    savebin "lain", #2000, $ - #2000