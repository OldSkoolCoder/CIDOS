;*******************************************************************************
;* Scratch Routine                                                             *
;* Syntax : Scratch or s shifted C 'filename'                                  *
;*******************************************************************************

SCRATCH
    lda #"s"                ; Load Scratch Disk Command
    sta DosCommandBuffer    ; Store it in DOS Buffer
    lda #CHR_Colon          ; Loads ':'
    sta DosCommandBuffer+1  ; Stores it in DOS Buffer
    ldy #2                  ; Sets Y Index for DOS Buffer

    CHRGETSpaceCheck 255
    GetFilenameFromCommandLine DosCommandBuffer
    CHRGETSpaceCheck CHR_Space
    jmp DOS
