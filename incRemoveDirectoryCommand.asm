;*******************************************************************************
;* RemoveDIR Routine                                                           *
;* Syntax : EraseDIR or e shifted R 'Directory Name'                           *
;*******************************************************************************

REMOVEDIR
    jsr CHRGOT              ; Check For Characters
    bne RDR_GetFileName     ; Characters, Jump To Inform
    jmp SYNTAX_ERROR        ; No Characters Found, Send Syntax Error

RDR_GetFileName
    ldy #0                  ; Init DOS Buffer Index
    lda #"r"                ; Load Mount Disk Command
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
    jmp DOS
