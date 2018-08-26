;*******************************************************************************
;* Copy Routine                                                                *
;* Syntax : Copy or c shifted O 'file1'to'file2'                               *
;*******************************************************************************
COPY
    lda #"c"                ; Load DOS Command for Copy
    jmp ProcessFromToCommand; Find the two filenames
