;*******************************************************************************
;* Header Routine                                                              *
;* Syntax : Header or h shifted E 'diskname',i(id)                             *
;*******************************************************************************

HEADER
    lda #"n"                ; Load DOS Command
    sta DosCommandBuffer    ; Store in Buffer
    lda #CHR_Colon          ; Load ":"
    sta DosCommandBuffer+1  ; Store in Buffer
    ldy #2                  ; Load Buffer Y Index

    CHRGETSpaceCheck 255
    GetFilenameFromCommandLine DosCommandBuffer
    CHRGETSpaceCheck CHR_Space

    sty FREERAMLAST     ; Store Buffer Index Y Temporarily
    jsr CHRGET          ; Get Next Command Character
    cmp #CHR_Comma      ; Is it a ','
    beq HD_GetDiskID    ; Yes, the get ID
    jmp DOS             ; No, then Perform Header DOS Operation

HD_GetDiskID
    ldy FREERAMLAST         ; Load DOS Buffer Index Y
    CHRGETSpaceCheck 255
    ;jsr CHRGET              ; Get Next Character
    lda #CHR_Comma          ; Load a ','
    sta DosCommandBuffer,y  ; Store in DOS buffer
    iny                     ; increase DOS Buffer Index
    jsr CHRGET              ; Get Disk ID
    sta DosCommandBuffer,y  ; Store In DOS Buffer
    iny 
    jsr CHRGET              ; Get Disk ID 2
    sta DosCommandBuffer,y  ; Store in DOS Buffer
    iny
    CHRGETSpaceCheck CHR_Space
 
    jmp dos             ; Jump To DOS Function To Perform Operation

