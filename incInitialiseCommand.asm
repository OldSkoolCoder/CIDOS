;******************************************************************************
;* Initialise Routine                                                          *
;* Syntax : initialise or I shifted N                                          *
;*******************************************************************************
INITIALISE
    lda #"i"                ; Store DOS Instruction in Accumulator

;*******************************************************************************
;* OneLetterDosCommand Routine                                                 *
;* *****************************************************************************
;* Input Registers :                                                           *
;*     Accumulator : holds the single DOS command character                    *
;*******************************************************************************
OneLetterDosCommand
    sta DosCommandBuffer    ; Store Dos Command into buffer
    ldy #1                  ; Set Length of buffer
    jmp DOS                 ; Perform DOS Command