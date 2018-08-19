;*******************************************************************************
;*  Error Handler                                                              *
;*******************************************************************************
;* Input Registers :                                                           *
;*  X = Error Number                                                           *
;*******************************************************************************

ErrorHandlerLo  = $22
ErrorHandlerHi  = $23

ErrorHandler
    txa
    pha                     ; Store Away Error Code
    cmp #30
    bcc @ROMError           ; less than 30
    sec
    sbc #30                 ; Subtract Our Error Code start
    asl                     ; Multiply By Two
    tax
    lda @ErrorCodes,x
    sta ErrorHandlerLo
    lda @ErrorCodes+1,x
    sta ErrorHandlerHi
    pla                     ; Retrieve Back Error Code
    jmp bas_CustomError$

@ROMError
    pla                     ; Retrieve Back Error Code
    tax
    jmp bas_ROMError$

@ErrorCodes
    WORD ERRORCODE_30        ; Error Code 30
    WORD ERRORCODE_31        ; Error Code 31
    WORD ERRORCODE_32        ; Error Code 32
    WORD ERRORCODE_33        ; Error Code 33
    WORD ERRORCODE_34        ; Error Code 34
    WORD ERRORCODE_35        ; Error Code 35

ERRORCODE_30
    TEXT "Error Code 30"
    BRK

ERRORCODE_31
    TEXT "Error Code 31"
    BRK

ERRORCODE_32
    TEXT "Error Code 32"
    BRK

ERRORCODE_33
    TEXT "Error Code 33"
    BRK

ERRORCODE_34
    TEXT "Error Code 34"
    BRK

ERRORCODE_35
    TEXT "Error Code 35"
    BRK

;*******************************************************************************
;* Show Syntax Error                                                           *
;*******************************************************************************
SYNTAX_ERROR
    lda #32
    sta 129
    ldx #11                 ; Code for Syntax Error
    jmp (jmpvec_Error)      ; Display Error Message

