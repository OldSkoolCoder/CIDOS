;*******************************************************************************
;* Marcos                                                                      *
;*******************************************************************************
;defm PrintUCommand
;*******************************************************************************
;* Parameter List                                                              *
;*      Input /1 = Track Number                                                *
;*      Input /2 = Sector Number                                               *
;*      Input /3 = Command Text                                                *
;*******************************************************************************

;*******************************************************************************
;defm CHRGETSpaceCheck                                                         *
;*******************************************************************************
;* Parameter List                                                              *
;* /1 the character we want to check for instead of space                      *
;*******************************************************************************

defm CHRGETSpaceCheck

    lda #/1
    sta CHRGETSPACE

endm

;*******************************************************************************
;defm GetFilenameFromCommandLine                                               *
;*******************************************************************************
;* Parameter List                                                              *
;*      Input /1 = Filename Location                                           *
;*******************************************************************************

defm GetFilenameFromCommandLine

@GetFileName
    jsr CHRGET              ; Get Next Character From Command Line
    cmp #CHR_Quote          ; Found a "?
    beq @GotFileName        ; Yes, That is the filename found
    sta /1,y                ; Store Character into Buffer
    iny                     ; Increase Buffer Index
    jmp @GetFileName         ; Get Next Character of Filename

@GotFileName

endm

;*******************************************************************************
;defm GetTOFromCommandLine                                                     *
;*******************************************************************************
;* Parameter List                                                              *
;*******************************************************************************

defm GetTOFromCommandLine

    jsr CHRGET              ; Get Next Character from command line
    cmp #"t"                ; Is it an 't'
    beq @Found_T            ; Yes, Find Next Command Character
    cmp #$A4                ; Tokanised Command for 'TO'
    beq @Found_O            ; Yes, Found Tokan for 'TO'
    jmp SYNTAX_ERROR        ; No, Jump Out with a SYNTAX ERROR

@Found_T
    jsr CHRGET
    cmp #"o"                ; is it an 'o'
    beq @Found_O            ; Yes, Find Next FileName
    jmp SYNTAX_ERROR        ; No, Jump Out with a SYNTAX ERROR

@Found_O
endm

defm PrintUCommand
;*******************************************************************************
;* Parameter List                                                              *
;*      Input /1 = Track Number                                                *
;*      Input /2 = Sector Number                                               *
;*      Input /3 = Command Text                                                *
;*******************************************************************************
    stx /1
    sty /2
    ldx #1                  ; Load Logial File Number
    jsr krljmp_CHKOUT$      ; Sets Output Device
    lda #</3                ; Load LoByte DOS Buffer Address
    ldy #>/3                ; Load HiByte DOS Buffer Address
    jsr bas_PrintString$    ; Print String @ Acc, Y
    lda #0
    ldx /1
    jsr bas_DecimalPrint$
    lda #","
    jsr krljmp_CHROUT$
    lda #0
    ldx /2
    jsr bas_DecimalPrint$
    jsr krljmp_CLRCHN$      ; Clear Channel
    rts
    endm
;*******************************************************************************

