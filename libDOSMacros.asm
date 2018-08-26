;*******************************************************************************
;* Marcos                                                                      *
;*******************************************************************************
;defm PrintUCommand
;*******************************************************************************
;* Parameter List                                                              *
;*      Input /1 = Track Number                                                *
;*      Input /2 = Sector Number                                               *
;*      Input /3 = Command Text                                                *
;*******************************************************************************

;*******************************************************************************
;defm GetFilenameFromCommandLine                                               *
;*******************************************************************************
;* Parameter List                                                              *
;*      Input /1 = Filename Location                                           *
;*******************************************************************************

defm GetFilenameFromCommandLine

@GetFileName
    jsr CHRGET              ; Get Next Character From Command Line
    cmp #CHR_Quote          ; Found a "?
    beq @GotFileName        ; Yes, That is the filename found
    sta /1,y                ; Store Character into Buffer
    iny                     ; Increase Buffer Index
    jmp @GetFileName         ; Get Next Character of Filename

@GotFileName

endm

;*******************************************************************************
;defm GetTOFromCommandLine                                                     *
;*******************************************************************************
;* Parameter List                                                              *
;*******************************************************************************

defm GetTOFromCommandLine

@NotFoundTo
    jsr CHRGET              ; Get Next Character from command line
;    cmp #"t"                ; Is it an 't'
    cmp #" "
    beq @NotFoundTo
    cmp #$A4                ; Tokanised Command for 'TO'
    beq @Found_T            ; Yes, Find Next Command Character
    jmp SYNTAX_ERROR        ; No, Jump Out with a SYNTAX ERROR

@Found_T
;    jsr CHRGET
;    cmp #"o"                ; is it an 'o'
;    beq @Found_O            ; Yes, Find Next FileName
;    jmp SYNTAX_ERROR        ; No, Jump Out with a SYNTAX ERROR

;@Found_O
endm
