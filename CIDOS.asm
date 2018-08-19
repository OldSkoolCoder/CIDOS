;*******************************************************************************
;* Commodore Intergrated Disk Operation System                                 *
;*                                                                             *
;* Writtern By John C. Dale                                                    *
;*                                                                             *
;* Date 5th February 2018                                                      *
;*******************************************************************************
;*                                                                             *
;* Change History                                                              *
;* 5th Feb 2018  : Created new project for use in the new CIDOS Video Series   *
;* 11th Feb 2018 : Added Error handling routine, and added the STATUS and the  *
;*                 Initialisation Commands                                     *
;*******************************************************************************

;*******************************************************************************
;* Includes                                                                    *
;*******************************************************************************

ifdef TGT_C64
    *= $8000
endif

         
ifdef TGT_VIC20_8K
    *= $A000
endif

incasm "libErrorCodes.asm"
incasm "libROMRoutines.asm"
incasm "libDOSMacros.asm"
incasm "Character_ASCII_Const.asm"

;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************

CHRGET      = $0073
CHRGOT      = $0079

DosCommandBuffer    = $033C

ifdef TGT_C64
SCROLX  =$D016
endif

DiskCommandChannelNumber = 15

;*******************************************************************************
;* Code                                                                        *
;*******************************************************************************

incasm "incInitialiseCommand.asm"
incasm "incStatusCommand.asm"

;*******************************************************************************
;* Show Ready Prompt                                                           *
;*******************************************************************************
READY
    lda #32
    sta 129
    jmp bas_ReadyPrompt$       ; Ready Prompt

incasm "libDOSRoutines.asm"
incasm "libErrorHandler.asm"

;*******************************************************************************
;* Storage Locations                                                           *
;*******************************************************************************
DEVICE_NUMBER
    BYTE 08
;PREVIOUS_BASIC_JUMP_VECTORS
;    WORD 0
;PREVIOUS_ERROR_JUMP_VECTORS
;    WORD 0
FILENAME
    TEXT "0000000000000000000"
    BRK
;LOCK_UNLOCK_COMMAND
;    BYTE " "                ; L = Lock, U = Unlock
;CURRENTTRACKNO
;    BYTE 0
;CURRENTSECTORNO
;    BYTE 0
;NEXTTRACKNO
;    BYTE 0
;NEXTSECTORNO
;    BYTE 0