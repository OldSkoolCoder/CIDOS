;*******************************************************************************
;* Cartridge Initialisation Routine                                            *
;*******************************************************************************

ERRORJUMPVECTOR = $0300
BASICJUMPVECTOR = $0304

    word reset
    word nmi

ifdef TGT_C64
    TEXT "CBM80"
endif

         
ifdef TGT_VIC20_8K
    TEXT "CBMA0"
endif

RESET
ifdef TGT_C64
    stx SCROLX
endif
    jsr krljmp_IOINIT$      ; CIA IO Initialisation
    jsr krljmp_RAMTAS$      ; Perform RAM Test
    jsr krljmp_RESTOR$      ; Restore RAM Vectors
    jsr krljmp_PCINT$       ; Initialise Screen Editor and VIC Chip
    cli
 
ifdef TGT_C64
    jsr $E453               ; Copy BASIC Vectors To RAM
    jsr $E3BF               ; Initialise BASIC
    lda #<CARTSTART-1        ; Protect DOS by reducing basic free bytes down
    sta 55                  ; Top Of Basic Lo
    lda #>CARTSTART-1
    sta 56                  ; Top Of Basic Hi
    jsr $E422               ; Print BASIC Start-Up Message
endif

         
ifdef TGT_VIC20_8K
    jsr $E45B               ; Copy BASIC Vectors To RAM
    jsr $E3A4               ; Initialise BASIC
    jsr $E404               ; Print BASIC Start-Up Message
endif

    ldx #$fb                ; Load Stack Pointer Start Value
    txs                     ; Transfer to StackPointer
    lda #<nmi_text+1        ; Load LoByte value of Text
    ldy #>nmi_text          ; Load HiByte value of Text
    jsr bas_PrintString$    ; String Out Routine
    jsr START               ; GoSub my Start Routine
    jmp NMI_EXIT            ; Jump To NMI_Exit

NMI
    jsr $f6bc               ;
    jsr krljmp_STOP$        ; Check STOP Key
    beq @NMI
    jmp $fe72               ; NMI RS232 Handler
@NMI
    jsr krljmp_RESTOR$      ; Restore RAM Vectors
    jsr krljmp_IOINIT$      ; CIA IO Initialisation
    jsr krljmp_PCINT$       ; Initialise Screen and Keyboard
    jsr krljmp_CLRCHN$      ; Restore Input and Output Devices
    lda #0                  
    sta 13
    jsr $a67a               ; Perform CLR
    cli 
    lda #<nmi_text          ; Load LoByte value of Text
    ldy #>nmi_text          ; Load HiByte value of Text
    jsr bas_PrintString$    ; String Out Routine
    jsr start               ; GoSub my Start Routine
NMI_EXIT
    ldx #128
    jmp ($0300)             ; Jump to Normal NMI Interupt

ifdef TGT_C64
NMI_TEXT
    BYTE CHR_ClearScreen
    BYTE CHR_CursorDown
    ;COLS"1234567890123456789012345678901234567890"
    TEXT " the intergrated disc operating system  "
    BYTE CHR_CursorDown
    TEXT "cidos v1.010a (c) feb 2018 oldskoolcoder"
    brk 
endif

ifdef TGT_VIC20_8K
NMI_TEXT
    BYTE CHR_ClearScreen
    BYTE CHR_CursorDown
    ;COLS"1234567890123456789012"
    TEXT "the c= intergrated dos"
    BYTE CHR_CursorDown
    TEXT "     cidos v1.010a"
    BYTE CHR_Return
    TEXT "(c) 2018 oldskoolcoder"
    brk 
endif

;*******************************************************************************
;* Start Routine                                                               *
;*******************************************************************************
START
    lda #10
    sta $02a2
    sta $02a4
    lda #0
    sta $02a3
    sta $02a5
ifdef TGT_C64
    jsr $E453               ; Copy BASIC Vectors To RAM
endif
         
ifdef TGT_VIC20_8K
    jsr $E45B               ; Copy BASIC Vectors To RAM
endif

    lda BASICJUMPVECTOR                 ; Get Current Jump Vectors
    sta PREVIOUS_BASIC_JUMP_VECTORS     ; Store away for use in kill command
    lda BASICJUMPVECTOR + 1             ; Get Current Jump Vectors
    sta PREVIOUS_BASIC_JUMP_VECTORS + 1 ; Store away for use in kill command
    lda ERRORJUMPVECTOR
    sta PREVIOUS_ERROR_JUMP_VECTORS
    lda ERRORJUMPVECTOR + 1
    sta PREVIOUS_ERROR_JUMP_VECTORS + 1
    lda #<tokan             ; Load LoByte of our Tokaniser Routine
    sta BASICJUMPVECTOR     ; Overload C64 Vector For Ours
    lda #>tokan             ; Load HiByte of our Tokaniser Routine
    sta BASICJUMPVECTOR + 1 ; Overload C64 Vector For Ours
    ;lda #<ERROR
    ;ldy #>ERROR
    ;sta $0300
    ;sty $0301
    lda #0                  ; Initial DOS Buffer Character
    tay                     ; Initial DOS Buffer Index
CLR
    sta DosCommandBuffer,y  ; Store in DOS Buffer
    iny                     ; Increase Index Y
    cpy #159                ; Reached End Of Buffer?
    bne CLR                 ; No, then continue initialisation
    ;jsr CloseDiskCommandChannel ; Just in case its open
    ;jsr OpenDiskCommandChannel; Yes, No Open Disk Command Channel
    lda #$7f                ; Set Basic Maximum Point to Protect DOS
    sta 56                  ; This will stop BASIC Encroaching on RAM
    sta 54                  ; Area $8000 or higher, while this is active
    sta 52
    lda #255
    sta 55
    sta 53
    sta 51
    jsr bas_NEWCommand$     ; Perform BASIC NEW Command
    rts                     ; Return Control back to C64

;ERROR
;    txa 
;    pha 
;    cmp #128
;    bne @ERROR1
;    jmp ready+4
;@ERROR1
;    lda 58
;    cmp #255
;    beq error1
;    sta 21
;    lda 57
;    sta 20
;    lda #13
;    jsr krljmp_CHROUT$
;    jsr bas_FindLine$
;    jsr list

;ERROR1
;    pla 
;    tax 
;    jmp (PREVIOUS_ERROR_JUMP_VECTORS)
