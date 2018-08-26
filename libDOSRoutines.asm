;*******************************************************************************
;* Open Disk Command Channel Routine                                           *
;*******************************************************************************
OpenDiskCommandChannel
    pha                 ; Temp Store Acc.
    tya
    pha                 ; Temp Store Y Reg
    txa
    pha                 ; Temp Store X Reg
    lda #DiskCommandChannelNumber   ; Load Logical File Number
    ldx DEVICE_NUMBER   ; Load Current Drive Device Number
    ldy #15             ; Load Command Type Number
    jsr krljmp_SETLFS$  ; Set Output Device
    lda #1              ; Load Length of Init String
    ldx #<STARTNM       ; Load LoByte Address of Init String
    ldy #>STARTNM       ; Load HiByte Address of Init String
    jsr krljmp_SETNAM$  ; Set Message Parameters for Channel
    jsr krljmp_OPEN$    ; Open File Number Command Channel
    bcs @ErrorReturned
    pla                 ; Get X Reg
    tax
    pla                 ; Get Y Reg
    tay
    pla                 ; Get Acc.
    rts

@ErrorReturned
    tax                 ; Move Error Code To X
    pla                 ; Get X
    pla                 ; Get Y
    pla                 ; Get Acc
    pla
    pla                 ; Pull JSR Pointers
    jmp ErrorHandler

;*******************************************************************************
;* Close Disk Command Channel Routine                                          *
;*******************************************************************************
CloseDiskCommandChannel
    jsr krljmp_CLRCHN$              ; Clear Channel
    lda #DiskCommandChannelNumber   ; Load Logial File Number
    jsr krljmp_CLOSE$               ; Close Logical File Number
    rts

STARTNM
    text "i"

;*******************************************************************************
;* Disk Operating System Routine                                               *
;* Inputs : Y Register is end of DOS Text                                      *
;*******************************************************************************
DOS
    jsr OpenDiskCommandChannel  ; Opens Disk Command Channel
    lda #CHR_Return             ; Load Carraige Return
    sta DosCommandBuffer,y      ; Store it at end Of DOS Instruction Line

;*************** Rem this line out once debugging is over **********************
    jsr ShowDOSCommand      ; Debug Information about command been sent

    jsr AreYouSurePrompt    ; Confirm Operation is Required?
    ldx #DiskCommandChannelNumber  ; Load Logial File Number
    jsr krljmp_CHKOUT$      ; Sets Output Device
    lda #<DosCommandBuffer  ; Load LoByte DOS Buffer Address
    ldy #>DosCommandBuffer  ; Load HiByte DOS Buffer Address
    jsr bas_PrintString$    ; Print String @ Acc, Y
    jsr krljmp_CLRCHN$      ; Clear Channel
    lda #0                  ; Init Acc.
    tay                     ; Init Y

DOS_ClearBuffer
    sta DosCommandBuffer,y  ; Clear Buffer
    iny                     ; Increase Looper
    cpy #195                ; Have we hit Byte 195 of Buffer
    bne DOS_ClearBuffer     ; No, Clear Next byte
    jmp ST_ChannelAlreadyOpen

;*******************************************************************************
;* Show DOS Command before Committing                                          *
;*******************************************************************************
ShowDOSCommand
    lda #<DosCommandBuffer  ; Load LoByte DOS Buffer Address
    ldy #>DosCommandBuffer  ; Load HiByte DOS Buffer Address
    jsr bas_PrintString$    ; Print String @ Acc, Y
    rts

;*******************************************************************************
;* Are You Sure Prompt                                                         *
;*******************************************************************************
AreYouSurePrompt
    lda #CHR_Return         ; Load Carraige Return
    jsr krljmp_CHROUT$      ; Print Character
    lda #<PROMPT_TEXT       ; Load LoByte Address
    ldy #>PROMPT_TEXT       ; Load HiByte Address
    jsr bas_PrintString$    ; Print String
    jsr krljmp_CHRIN$       ; Wait for a character response
    cmp #"y"                ; is it 'Y'
    bne AreYouSurePrompt1   ; No, then abort current operation
    rts                     ; Yes, Continue with operation

AreYouSurePrompt1
    jsr krljmp_CLRCHN$      ; Clear Channel
    jsr CloseDiskCommandChannel ; Closes the Command Channel
    pla                     ; Pull HiByte Return Vector
    pla                     ; Pull LoByte Return Vector
    jmp READY               ; Goto Ready Process

PROMPT_TEXT
    TEXT "are you sure ?n"
    BYTE CHR_CursorLeft   
    brk 

