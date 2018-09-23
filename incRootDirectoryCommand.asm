;*******************************************************************************
;* RootDir Routine                                                             *
;* Syntax : Rootdir or r shifted O                                             *
;*******************************************************************************

ROOTDIR
    ldy #0                  ; Init DOS Buffer Index
    lda #"c"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increas Index
    lda #"d"                ; Load Mount Disk Command
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; increase index
    lda #47                 ; Loads '/'
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increase Index
    lda #47                 ; Loads '/' 
    sta DosCommandBuffer,y  ; Store it in DOS Buffer
    iny                     ; Increase Index

    CHRGETSpaceCheck 255
    jmp DOS

