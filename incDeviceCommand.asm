;*******************************************************************************
;* Device Routine                                                              *
;* Syntax : Device or d shifted E DEVICE NUMBER#                               *
;*******************************************************************************

DEVICE
    jsr CHRGOT                          ; Check For Characters
    beq DEV_PrintCurrentDeviceNumber    ; No Characters, Jump To Inform
    jsr GetNumberFromCommandLine        ; Get Device Number to Change too
    bcs DEV_PrintCurrentDeviceNumber    ; No Device No, Jump to inform
    stx STRTHI                          ; Temp Store Device#
    jsr CloseDiskCommandChannel         ; Close existing Command Channel
    ldx STRTHI                          ; Get Back Device Number
    cpx #8
    bcc DEV_InvalidDeviceNumber         ; Device < 8
    cpx #12
    bcs DEV_InvalidDeviceNumber         ; Device > 11
    stx DEVICE_NUMBER                   ; Permanetly store device number
    ;jsr OpenDiskCommandChannel          ; Open Command Channel on new device

DEV_PrintCurrentDeviceNumber
    lda #<DEVICE_TEXT           ; Load LoByte value of Text
    ldy #>DEVICE_TEXT           ; Load HiByte value of Text
    jsr bas_PrintString$        ; String Out Routine
    lda #0                      ; Load HiByte Number
    ldx DEVICE_NUMBER           ; Load LoByte Number
    jsr bas_DecimalPrint$       ; Print Integer Number
    lda #CHR_Return             ; Load Carraige Return
    jsr krljmp_CHROUT$          ; Print Character
    jmp STATUS                  ; Goto Status Command

DEV_SyntaxError
    jmp SYNTAX_ERROR            ; Send Syntax Error

DEV_InvalidDeviceNumber
    ldx #err_InvalidDeviceNumber$
    jmp ErrorHandler

DEVICE_TEXT
    TEXT "current device is : "
    BRK

