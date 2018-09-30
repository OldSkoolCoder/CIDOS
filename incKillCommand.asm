;*******************************************************************************
;* KILL Routine                                                                *
;* Syntax : KILL or k shifted I                                                *
;*******************************************************************************

KILL
    lda PREVIOUS_BASIC_JUMP_VECTORS  ; Reset Lo Byte Jump Vector back to BASIC
    ldy PREVIOUS_BASIC_JUMP_VECTORS + 1 ; Reset Hi Byte Jump Vector back to BASIC
    sta jmpvec_Crunch   ; Reset Jump Vector
    sty jmpvec_Crunch+1 ; Reset Jump Vector
    lda #0              ; Destory CART Term Test at $8000

ifdef TGT_VIC20_8K
    sta $A004
endif

ifdef TGT_C64
    sta $8004           ; Store
endif

    jmp 64738           ; Do Soft-Reset