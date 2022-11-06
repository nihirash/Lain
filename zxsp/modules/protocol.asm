    module Protocol
LOAD_CHUNK equ 0x01
SET_PAGE   equ 0x02
JUMP       equ 0x03

router:
    call Wifi.getSocketByte
    cp JUMP       : jr z, jump
    cp SET_PAGE   : jr z, setPage
    cp LOAD_CHUNK : jr z, getChunk
    jr router
jump:
    call Wifi.getSocketWord
    push hl
    EspCmd "AT+RST"
    ret

setPage:
    call Wifi.getSocketByte
    or #10
    ld bc, #7ffd : out (c), a 
    jr router

getChunk:
    call Wifi.getSocketWord
    push hl
    call Wifi.getSocketWord
    ex de, hl
    pop hl
.downLoop
    ld a, d : or e : jp z, router

    push de : push hl
    call Wifi.getSocketByte
    pop hl : pop de
    ld (hl), a

    dec de : inc hl
    jr .downLoop

    endmodule