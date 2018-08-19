;*******************************************************************************
;* Status Routine                                                              *
;* Syntax : Status or s shifted H                                              *
;*******************************************************************************

STATUS
    jsr OpenDiskCommandChannel  ; Open Command Channel

ST_ChannelAlreadyOpen
    ldx #DiskCommandChannelNumber  ; Load Logical File Number
    jsr krljmp_CHKIN$       ; Set Input Device

    lda #CHR_Return         ; Load Carraige Return
    jsr krljmp_CHROUT$      ; Print Character

    lda #CHR_ReverseOn      ; Load Reverse Character
    jsr krljmp_CHROUT$      ; Print Character

@StartOfLine
    jsr krljmp_CHRIN$       ; Get Character From Input Channel
    cmp #CHR_Return         ; Is it carraige return?
    beq @EndOfLine        ; Yes, Goto End Of Line

    jsr krljmp_CHROUT$      ; No, Print that Character
    jmp @StartOfLine      ; Process Next Character

@EndOfLine
    lda #CHR_Return         ; load Carraige Return
    jsr krljmp_CHROUT$      ; Print Character
    jsr krljmp_CLRCHN$      ; Clear Channel
    jsr CloseDiskCommandChannel ; Closes the Disk Command Channel
    jmp ready               ; Goto Ready Process
