;*******************************************************************************
;* DisMount Routine                                                            *
;* Syntax : Dismount or d shifted I                                            *
;*******************************************************************************

DISMOUNT
    ldy #0                  ; Init DOS Buffer Index
    lda #"c"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increas Index
    lda #"d"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; increase index
    lda #CHR_Colon          ; Loads ':'
    sta DosCommandBuffer,y              ; Stores it in DOS Buffer
    iny                     ; Increase Index
    lda #95                 ; Loads '<-' (Arrow Left)
    sta DosCommandBuffer,y              ; Stores it in DOS Buffer
    iny                     ; Increase Index

    CHRGETSpaceCheck 255
    jmp DOS
