;*******************************************************************************
;* Mount Routine                                                               *
;* Syntax : Mount or m shifted O 'ImageName.d64'                               *
;*******************************************************************************

MOUNT
    jsr CHRGOT              ; Check For Characters
    bne MNT_GetFileName     ; Characters, Jump To Inform
    jmp SYNTAX_ERROR        ; No Characters Found, Send Syntax Error

MNT_GetFileName
    ldy #0                  ; Init DOS Buffer Index
    lda #"c"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increas Index
    lda #"d"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; increase index
    lda #CHR_Colon          ; Loads ':'
    sta DosCommandBuffer,y  ; Stores it in DOS Buffer
    iny                     ; Increase Index

    CHRGETSpaceCheck 255
    GetFilenameFromCommandLine DosCommandBuffer
    jmp DOS
