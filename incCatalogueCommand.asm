;*******************************************************************************
;* Catalogue Routine                                                           *
;* Syntax : Catalogue or c shifted A                                           *
;*******************************************************************************

CATALOG
    lda #8              ; Logial File Number
    ldx DEVICE_NUMBER   ; Device Number
    ldy #0              ; Secondary Address
    jsr krljmp_SETLFS$  ; Set Active File Parameters
    lda #2              ; Set Number of Characters
    ldx #<catnm         ; LoByte Address Of String
    ldy #>catnm         ; HiByte Address Of String
    jsr krljmp_SETNAM$  ; Set Parameter for filename
    jsr krljmp_OPEN$    ; Perform Open File Command
    bcc @NOOpenError
    tax
    jmp ErrorHandler    ; Error Detected, Jump to Handler

@NOOpenError
    ldx #8              ; Set Logical File Number
    jsr krljmp_CHKIN$   ; Set Input Device
    bcc @NoInputError
    tax
    jmp ErrorHandler    ; Error Detected, Jump to Handler

@NoInputError
    jsr krljmp_CHRIN$   ; Get Character (LoByte Start Address)
    lda $90
    bne CAT_Error
    jsr krljmp_CHRIN$   ; Get Character (HiByte Start Address)

CAT_GetNextBasicLine
    jsr krljmp_CHRIN$   ; Get Character (LoByte Linked Line)
    jsr krljmp_CHRIN$   ; Get Character (HiByte Linked Line)
    ;cmp #0              ; Is Character 'Zero'? (End Of Basic Program)
    beq Cat_End         ; If Yes, Jump to the END
    jsr krljmp_CHRIN$   ; Get LoByte Line Number
    sta $02a7           ; Store LoByte
    jsr krljmp_CHRIN$   ; Get HiByte Line Number
    ldx $02a7           ; Load X LoByte
    jsr bas_DecimalPrint$  ; Print Decimal Number X=Lo, Acc=Hi
    lda #CHR_Space      ; Space
    jsr krljmp_CHROUT$  ; Print Space

CAT_GETBasicLine
    jsr krljmp_CHRIN$   ; Get Character
    ;cmp #0              ; Is Character 'Zero'? (End Of Basic Line)
    beq CAT_EndOfBasicLine    ; Yes, Jump to Get Next Basic Line
    jsr krljmp_CHROUT$  ; Print Character
    jmp CAT_GETBasicLine; Get Next Character

CAT_EndOfBasicLine
    lda #CHR_Return     ; Load Carraige Return
    jsr krljmp_CHROUT$  ; Print Carraige Return
    ;jsr keytest         ; Test for Keyboard Activity
    jsr krljmp_STOP$    ; Check the RUN/STOP KEYTEST
    beq CAT_Break
    jmp CAT_GetNextBasicLine    ; Go Process Next Basic Line

CAT_END
    ;lda #CHR_Return     ; Load Carraige Return
    ;jsr krljmp_CHROUT$  ; Print Carraige Return
    jsr CAT_CloseFileNumber  ; Close File Number
    jmp READY           ; Goto READY Process

CAT_Error
    jsr CAT_CloseFileNumber  ; Close File Number

    ldx #err_DeviceNotReady$ ; Drive not ready Error Number
    jmp ErrorHandler

CAT_Break
    jsr CAT_CloseFileNumber ; Close File Number

    ldx #err_Break$         ; Break Error Number
    jmp ErrorHandler

CAT_CloseFileNumber
    jsr krljmp_CLRCHN$  ; Clear Channel
    lda #8              ; Load Logial File Number
    jsr krljmp_CLOSE$   ; Close Logical File Number
    rts

CATNM
    text "$0"

;*******************************************************************************
;* KeyTEST Routine                                                           *
;*******************************************************************************
KEYTEST
    lda $c5             ; Matrix Value of Last Key Pressed
    cmp #64             ; No Key Pressed?
    beq KT_END          ; Yes, Goto End Of Key Test
    jsr KT_LOOPER       ; No, Key has been Pressed, So Pause

KT_RETRY
    lda $c5             ; Matrix Value of Last Key Pressed
    cmp #64             ; No Key Presses?
    beq KT_RETRY        ; Yes, Try Again
    jsr KT_LOOPER       ; No, Key has been Pressed, So Pause

KT_END
    rts                 ; End Of Key Press Test

KT_LOOPER
    ldx #10             ; Loop For 10 Y Cycles

KT_OUTERLOOP
    ldy #255            ; Loop 255 times

KT_INNERLOOP
    dey                 ; Decrease Inner Loop Index
    bne KT_INNERLOOP    ; Hit Zero?, No, Loop Round
    dex                 ; Yes, Decrease Outer Loop Index
    bne KT_OUTERLOOP    ; Hit Zero?, No, Loop Round
    rts                 ; Yes, Exit

