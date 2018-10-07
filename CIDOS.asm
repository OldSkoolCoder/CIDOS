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
;* 16th Feb 2018 : Added the Collect, Rename and Copy Commands                 *
;* 20th Feb 2018 : Added the Scratch, Header and Device Commands               *
;* 24th Feb 2018 : Added the Catalogue and Chain Commands                      *
;* 26th Feb 2018 : Added Cartridge Initialisation and BASIC Tokaniser Routine  *
;* 1st Mar 2018  : Added Commands Mount, Dismount, RootDirectory,              *
;*                 ChangeDirectory, MakeDirectory and RemoveDirectory          *
;* 4th Mar 2018  : Added LockFile and UnlockFile Commands                      *
;* 10th Mar 2018 : Added Kill, Help and About Commands                         *
;* 22nd Mar 2018 : Add Code to allow conversion to crt Cartridge format        *
;*******************************************************************************

;*******************************************************************************
;* Includes                                                                    *
;*******************************************************************************

ifdef TGT_C64
    *= $8000
CARTSTART = $8000
endif

         
ifdef TGT_VIC20_8K
    *= $A000
CARTSTART = $A000
endif

incasm "incCartridgeInitate.asm"
incasm "incBASICTokaniser.asm"
incasm "libErrorCodes.asm"
incasm "libROMRoutines.asm"
incasm "libDOSMacros.asm"
incasm "libCharacterASCIIConst.asm"

;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************

CHRGET      = $0073
CHRGOT      = $0079
CHRGETSPACE = $81
FREERAM     = $02A7
FREERAMLAST = $02FF

STRTLO  =247
STRTHI  =248

DosCommandBuffer    = $033C

ifdef TGT_C64
SCROLX  =$D016
endif

DiskCommandChannelNumber = 15

;*******************************************************************************
;* Code                                                                        *
;*******************************************************************************

incasm "incAboutCommand.asm"
incasm "incHelpCommand.asm"
incasm "incKillCommand.asm"
incasm "incLockFileCommand.asm"
incasm "incUnlockFileCommand.asm"
incasm "incRemoveDirectoryCommand.asm"
incasm "incMakeDirectoryCommand.asm"
incasm "incChangeDirectoryCommand.asm"
incasm "incRootDirectoryCommand.asm"
incasm "incDismountCommand.asm"
incasm "incMountCommand.asm"
incasm "incChainCommand.asm"
incasm "incCatalogueCommand.asm"
incasm "incDeviceCommand.asm"
incasm "incHeaderCommand.asm"
incasm "incScratchCommand.asm"
incasm "incCopyCommand.asm"
incasm "incRenameCommand.asm"
incasm "incCollectCommand.asm"
incasm "incInitialiseCommand.asm"
incasm "incStatusCommand.asm"

;*******************************************************************************
;* Show Ready Prompt                                                           *
;*******************************************************************************
READY
    CHRGETSpaceCheck CHR_Space
    jmp bas_ReadyPrompt$       ; Ready Prompt

incasm "libDOSRoutines.asm"
incasm "libErrorHandler.asm"
incasm "libBASICRoutines.asm"
incasm "libLockUnlockRoutines.asm"

;*******************************************************************************
;* Storage Locations                                                           *
;*******************************************************************************
DEVICE_NUMBER               = $02A8
    ;BYTE 08
PREVIOUS_BASIC_JUMP_VECTORS = $02A9
    ;WORD 0
PREVIOUS_ERROR_JUMP_VECTORS = $02AB
    ;WORD 0
FILENAME                    = $02AD
    ;TEXT "0000000000000000000"
    ;BRK
LOCK_UNLOCK_COMMAND         = $02C1
    ;BYTE " "                ; L = Lock, U = Unlock
CURRENTTRACKNO              = $02C2
    ;BYTE 0
CURRENTSECTORNO             = $02C3
    ;BYTE 0
NEXTTRACKNO                 = $02C4
    ;BYTE 0
NEXTSECTORNO                = $02C5
    ;BYTE 0
LOCKNM                      = $02C6
    ;BYTE "#"
FilenameInSector            = $02C7
    ;BYTE 0
FileProtectionStatus        = $02C8
    ;BYTE 0
FilenameStringIndex         = $02C9
    ;BYTE 0
FoundFileName               = $02CA
    ;BYTE 0
BPPosition                  = $02CB
    ;BYTE 0
U2TrackNo                   = $02CC
    ;BYTE 0
U2SectorNo                  = $02CD
    ;BYTE 0
U1TrackNo                   = $02CE
    ;BYTE 0
U1SectorNo                  = $02CF
    ;BYTE 0
*=$9FFF
    BRK
