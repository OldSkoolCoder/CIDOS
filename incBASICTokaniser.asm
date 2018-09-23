;*******************************************************************************
;* Tokaniser Routine                                                           *
;*******************************************************************************
TOKAN
    lda 157                         ; Loads Program Mode Status
    bpl TK_NonDirectMode            ; If Plus (<128), Away From Tokaniser 
    jsr TK_TokaniserReset           ; Resets Basic Command Line Tokaniser
    jsr chrget                      ; Get First Command Line Character
    bcs TK_FoundTokanInstruction    ; Found Tokan, Now to process
    jsr bas_LineGet$                ; Back To C64 Basic For Line Number
    jmp (PREVIOUS_BASIC_JUMP_VECTORS) ; Change Line To Interpreter Mode

TK_NonDirectMode
    jmp TK_ReturnBackToC64

TK_FoundTokanInstruction
    ldy #0                  ; Initialise Tokeniser
    sty 97                  ; Reset Vectors
    sty 98                  ; Reset Vectors
    lda #255
TK10
    ldy 122                 ; Load Current Index of Basic Text
TK11
    lda 98                  ; Load Basic Pointer
    cmp #3
    lda 512,y               ; Load Next Character
    bcc tk5                 ; no match as yet
    beq tk6                 ; Found command
    cmp #32
    beq tk6
TK5
    inx 
    sec                     ; set carry for subtract 
    sbc Command_LIST,x      ; subtract table byte
    beq tk7                 ; go compare next if match
    cmp #$80                ; was it end marker match ?
    beq tk8                 ; Branch, if keyword found
    inc 97                  ; if not, not found keyword
    lda #0
    sta 98
    dex 
TK9
    inx 
    lda Command_LIST,x
    bpl tk9
    lda Command_LIST+1,x
    bne tk10
    beq TK_ReturnBackToC64
TK7
    inc 98
    iny 
    bne tk11
TK6
    dey 
TK8
    sty 122
    lda 97                  ; get command index value
    asl                     ; multiply index by 2 
    tax                     ; transfer index to index register
    lda Command_ADDR+1,x    ; Get Hi Byte Jump vector for command
    pha 
    lda Command_ADDR,x      ; Get Lo Byte Jump Vector for command
    pha 
    jmp chrget              ; return to the command 

TK_TokaniserReset
    lda #255
    sta 122
    lda #1
    sta 123
    rts 

TK_ReturnBackToC64
    jsr TK_TokaniserReset   ; Return Tokaniser back to C64
    jsr chrget
    jmp (PREVIOUS_BASIC_JUMP_VECTORS)

;*******************************************************************************
;* Command List                                                                *
;*******************************************************************************
Command_LIST
    TEXT "cataloG"
    TEXT "statuS"
    TEXT "initialisE"
    TEXT "collecT"
    TEXT "renamE"
    TEXT "copY"
    TEXT "scratcH"
    TEXT "headeR"
    TEXT "devicE"
    TEXT "chaiN"
    TEXT "mounT"
    TEXT "dismounT"
    TEXT "rootdiR"
    TEXT "changediR"
    TEXT "makediR"
    TEXT "removediR"
    brk 

;*******************************************************************************
;* Command List Addresses                                                      *
;*******************************************************************************
Command_ADDR
    WORD CATALOG-1
    WORD STATUS-1
    WORD INITIALISE-1
    WORD COLLECT-1
    WORD RENAME-1
    WORD COPY-1
    WORD SCRATCH-1
    WORD HEADER-1
    WORD DEVICE-1
    WORD CHAIN-1
    WORD MOUNT-1
    WORD DISMOUNT-1
    WORD ROOTDIR-1
    WORD CHANGEDIR-1
    WORD MAKEDIR-1
    WORD REMOVEDIR-1

