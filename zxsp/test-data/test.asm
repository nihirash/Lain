    device zxspectrum48
    org 0

LOAD_CHUNK = 1
SET_PAGE = 2
JUMP = 3

    dup 3

    db SET_PAGE
    db 8

    db LOAD_CHUNK
    dw #4000
    dw 6912
    incbin "1.scr"
    
    db SET_PAGE
    db 7
    
    db LOAD_CHUNK
    dw #c000
    dw 6912
    incbin "2.scr"
    
    edup
    
    db JUMP
    dw #2000
    
    savebin "test.pct", 0, $