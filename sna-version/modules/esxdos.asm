    module EsxDOS

ESX_GETSETDRV = #89
ESX_EXEC = #8F
ESX_FOPEN = #9A
ESX_FCLOSE = #9B
ESX_FSYNC = #9C
ESX_FWRITE = #9E


FMODE_CREATE = #0E

CMD_BUFF = 23512

prepareFile:
    xor a
    rst #8
    db ESX_GETSETDRV

    ld hl, filename
    ld b, FMODE_CREATE
    rst #8 
    db ESX_FOPEN
    jp c, .err

    ld (fhandle), a
    ret
.err
    pop ix
    ret

;; BC - chunk size
writeChunk:
    ld hl, buffer
    ld a, (fhandle)
    rst #8 : db ESX_FWRITE
    ret

closeAndRun:
    ld a, (fhandle)
    rst #8 : db ESX_FSYNC

    ld a, (fhandle)
    rst #8 : db ESX_FCLOSE
    
    ld hl, command
    ld de, CMD_BUFF
    ld bc, size
    ldir

    ld hl, CMD_BUFF
    ei
    rst #8
    db ESX_EXEC
    ret
    

fhandle db 0
command db "snapload "
filename db "/tmp/lain.sna", 0
size = $ - command
    endmodule