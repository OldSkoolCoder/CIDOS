;*******************************************************************************
;* ChangeDIR Routine                                                           *
;* Syntax : Switchdir or s shifted W 'Directory Name'                          *
;*******************************************************************************

CHANGEDIR
    jsr CHRGOT              ; Check For Characters
    bne CDIR_GetDirectoryName; Characters, Jump To Inform
    jmp SYNTAX_ERROR        ; No Characters Found, Send Syntax Error

CDIR_GetDirectoryName
    ldy #0                  ; Init DOS Buffer Index
    lda #"c"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increas Index
    lda #"d"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; increase index
    lda #CHR_Colon          ; Loads ':'
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increase Index

    CHRGETSpaceCheck 255

    GetFilenameFromCommandLine DosCommandBuffer

    ;lda #47                 ; Loads '/'
    ;sta DosCommandBuffer,y  ; Store it in DOS Buffer
    ;iny                     ; Increase Index
    jmp DOS

