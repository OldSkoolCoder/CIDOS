;*******************************************************************************
;* Rename Routine                                                              *
;* Syntax : rename or r shifted E 'file1' to 'file2'                           *
;*******************************************************************************
RENAME
    lda #"r"                ; DOS Command for RENAME

;*******************************************************************************
;* ProcessToFrom Routine                                                       *
;* Finds the filename 1 and filename 2                                         *
;*******************************************************************************
;* End Result of this should be a dos command like :                           *
;* ?:FileName2=Filename1                                                       *
;*******************************************************************************
ProcessFromToCommand
    sta DosCommandBuffer    ; Store in DOS Buffer
    lda #CHR_Colon          ; DOS Command seperator ':'
    sta DosCommandBuffer+1  ; Store in character character of Buffer
    ;lda #255                ; Load 255 in Acc
    ;sta 129                 ; Store it in 129
    ldy #0                  ; Init Y

    GetFilenameFromCommandLine FREERAM

    sty FREERAMLAST         ; Temp Store Dos Buffer Index Away

    GetTOFromCommandLine

    jsr CHRGET              ; Get Next Character from command line
    ldy #2                  ; Start Index Y @ 2

    GetFilenameFromCommandLine DosCommandBuffer

    lda #CHR_Equals         ; Load '='
    sta DosCommandBuffer,y  ; store in DOS Buffer
    iny                     ; Increase Y Index
    ldx #0                  ; Init X Index

@GetSecondFileName
    lda FREERAM,x           ; Load Character From First FileName
    sta DosCommandBuffer,y  ; Store in DOS Buffer   
    iny                     ; Increase DOS Buffer Index
    inx                     ; Increase Filename1 Index
    cpx FREERAMLAST         ; Compare X with length of Filename1
    bne @GetSecondFileName  ; Not got there yet, go back for next character
    jmp DOS                 ; Perform DOS Command

