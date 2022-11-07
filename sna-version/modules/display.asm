    module Display
putStr:
    ld a, (hl) : and a : ret z
    push hl
    rst #10
    pop hl
    inc hl
    jr putStr

    endmodule

    macro printMsg ptr
    ld hl, ptr : call Display.putStr
    endm