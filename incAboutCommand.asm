;*******************************************************************************
;* About Routine                                                               *
;* Syntax : About or a shifted B                                               *
;*******************************************************************************

ABOUT
    lda #<about_txt
    ldy #>about_txt
    jmp ABIE    ; Print Out About Text

ABOUT_TXT
    BYTE CHR_ClearScreen, CHR_CursorDown, CHR_CursorDown
    TEXT "dalesoft computers proudly presents....."
    TEXT "           cidos v1.20 alpha            "
    BYTE CHR_CursorDown, CHR_CursorDown
    TEXT "commodore intergrated disc operating    "
    TEXT "system for the commodore 64             "
    TEXT "  (c) february 2018 dalesoft computers. "
    BYTE CHR_CursorDown
    TEXT "if you have any suggestions or features,"
    TEXT "please email me on johndale@dalesoft.com"
    BYTE CHR_CursorDown
    TEXT "this program is distributed in the hope "
    TEXT "it will take the complexity of talking  "
    TEXT "to a floppy disc and a sd2iec sdcard    "
    TEXT "easier, and you will find this useful.  "
    BYTE CHR_Return, CHR_CursorDown
    TEXT "the program is provided with no warranty"
    TEXT "of any kind."
    BYTE CHR_Return
    TEXT "use this program at your own risk."
    BYTE CHR_Return
    TEXT "enter 'help' for further instructions."
    brk 