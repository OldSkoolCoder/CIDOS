;*******************************************************************************
;* Help Routine                                                                *
;* Syntax : Help or h shifted E                                                *
;*******************************************************************************

HELP
    lda #<help_txt
    ldy #>help_txt
    jmp ABIE

HELP_TXT
    TEXT "oldskoolcoders dos and sd2iec aid for 64"
    TEXT "EEEEEEEEEEEEEE EEE EEE EEEEEE EEE EEE EE"
    BYTE CHR_ReverseOn
    TEXT "catalog"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "initialize"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "status"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "collect"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "rename"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "filename1"
    BYTE CHR_Quote
    TEXT " to "
    BYTE CHR_Quote
    TEXT "filename2"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "copy"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "filename1"
    BYTE CHR_Quote
    TEXT " to "
    BYTE CHR_Quote
    TEXT "filename2"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "scratch"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "filename1"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "header"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "disc name"
    BYTE CHR_Quote
    TEXT ",XX (2 digit code)"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "chain"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "filename1"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "kill"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "help"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "device"
    BYTE CHR_ReverseOff
    TEXT " device#"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "mount"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "imagename"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "dismount"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "rootdir"
    BYTE CHR_Return, CHR_ReverseOn
    TEXT "switchdir"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "directory name"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "makedir"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "directory name"
    BYTE CHR_Quote, CHR_Return
    BYTE CHR_ReverseOn
    TEXT "erasedir"
    BYTE CHR_ReverseOff, CHR_Space, CHR_Quote
    TEXT "directory name"
    BYTE CHR_Quote, CHR_Return, CHR_ReverseOn
    TEXT "about"
    BYTE CHR_ReverseOff
    brk 