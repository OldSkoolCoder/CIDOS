;*******************************************************************************
;* Lock and Unlock Routines                                                    *
;*                                                                             *
;*******************************************************************************

ProcessLockUnLockCommand
    ldy #16
    lda #160
ClearFilename
    sta FILENAME,y          ; Blank Out Filename Space
    dey
    bpl ClearFilename

    jsr CHRGOT              ; Check For Characters
    bne LF_GetFileName      ; Characters, Jump To Inform
    jmp SYNTAX_ERROR        ; No Characters Found, Send Syntax Error

LF_GetFileName
    CHRGETSpaceCheck 255

    ldy #0
    GetFilenameFromCommandLine FILENAME

    lda #18                 ; Set to Track 18
    sta CURRENTTRACKNO
    lda #1                  ; Start at Sector 1
    sta CURRENTSECTORNO

    jsr OpenAllFileNumbersForLockUnlockSystem

GetNextTrackAndSectorsData
    ldx CURRENTTRACKNO          ; set TrackNo to Read
    ldy CURRENTSECTORNO         ; set SectorNo to Read
    jsr PrintU1Command          ; Get Disk Read to read that track/Sector

    lda #0
    jsr PrintBPCommand          ; Set Byte Position in the sector = 0

    jsr GetDirectoryCharacter
    sta NEXTTRACKNO             ; Get Next Track No for directory
    jsr GetDirectoryCharacter
    sta NEXTSECTORNO            ; Get Next Sector No for directory

    lda #0
    sta FilenameInSector        ; store filename index in sector

GetNextFilename
    jsr PointToNextFilenameLocation
    jsr GetDirectoryCharacter   ; Get FileProtectionStatus
    sta FileProtectionStatus

    jsr GetDirectoryCharacter   ; Get filename track
    jsr GetDirectoryCharacter   ; get filename sector

    ldy #0
    sty FilenameStringIndex     ; init string index for filename matching
    lda #$FF                    ; By Default Say we have found filename
    sta FoundFileName

GetNextFilenameCharacter
    jsr GetDirectoryCharacter   ; Get Filename Character
    cmp FILENAME,y              ; Is it same as ours ?
    beq ToNextFilenameCharacter ; yes, get next filename character to test
    lda #0                      ; Filename is different
    sta FoundFileName

ToNextFilenameCharacter
    iny                         ; increment for next character
    sty FilenameStringIndex
    cpy #16                     ; only 16 characters in a filename in BAM
    bne GetNextFilenameCharacter; get next charater of filename

WasTheFileFound
    lda FoundFileName
    cmp #$FF                    ; Did we find the file?
    bne NeedToTestNextFilename  ; No, Got to next Filename
    jmp ProcessProtectionOfTheFilename  ; Process FILE

NeedtoTestNextFilename
    inc FilenameInSector        ; Increase Filenumber
    lda FilenameInSector
    cmp #7                      ; Last one in sector?
    bne GetNextFilename         ; No, get next one

    lda NEXTSECTORNO            ; Change Next Sector to Current
    sta CURRENTSECTORNO
    lda NEXTTRACKNO             ; Change Next Track To Current
    sta CURRENTTRACKNO

    cmp #0                      ; Last Track Detected
    beq FileWasNotFound         ; Yes, then file was not found
    jmp GetNextTrackAndSectorsData  ; No, get next data

FileWasNotFound
    jsr CloseAllFileNumbersForLockUnlockSystem
    ldx #4                  ; File Not Found Error#
    jmp ErrorHandler

PointToNextFilenameLocation
    lda FilenameInSector
    asl                     ; x2
    asl                     ; x4
    asl                     ; x8
    asl                     ; 16
    asl                     ; 32
    clc
    adc #2                  ; adds 2
    jmp PrintBPCommand

ProcessProtectionOfTheFilename
    jsr PointToNextFilenameLocation
    lda LOCK_UNLOCK_COMMAND
    cmp #"U"
    bne ProcessLockedFileName
    lda FileProtectionStatus
    and #191
    sta FileProtectionStatus
    jmp CommitLockedChanges

ProcessLockedFileName
    lda FileProtectionStatus
    ora #64
    sta FileProtectionStatus

CommitLockedChanges
    ldx #10                 ; Load Logial File Number
    jsr krljmp_CHKOUT$      ; Sets Output Device
    lda FileProtectionStatus
    jsr krljmp_CHROUT$      ; Print Protection Value
    jsr krljmp_CLRCHN$      ; Clear Channel

    ldx CURRENTTRACKNO          ; set TrackNo to Read
    ldy CURRENTSECTORNO         ; set SectorNo to Read
    jsr PrintU2Command          ; Get Disk Read to read that track/Sector

    jsr CloseAllFileNumbersForLockUnlockSystem

    lda LOCK_UNLOCK_COMMAND
    cmp #"U"
    bne PrintLockedText
    
    lda #<FILEUNLOCKED      ; Load LoByte DOS Buffer Address
    ldy #>FILEUNLOCKED      ; Load HiByte DOS Buffer Address
    jmp PrintLockConfirmation

PrintLockedText
    lda #<FILELOCKED        ; Load LoByte DOS Buffer Address
    ldy #>FILELOCKED        ; Load HiByte DOS Buffer Address

PrintLockConfirmation
    jsr bas_PrintString$
    jmp Ready

FILELOCKED
    TEXT "file has now been locked",0

FILEUNLOCKED
    TEXT "file has now been unlocked",0

;*******************************************************************************
;* OpenAllFileNumbersForLockUnlockSystem                                       *
;* Input Parameters : None                                                     *
;* Output Parameters : None                                                    *
;*******************************************************************************
OpenAllFileNumbersForLockUnlockSystem
    ; Setting Up Outbound Command Channel #1
    lda #1              ; Logial File Number
    ldx DEVICE_NUMBER   ; Device Number
    ldy #15             ; Secondary Address
    jsr krljmp_SETLFS$  ; Set Active File Parameters
    jsr krljmp_OPEN$    ; Perform Open File Command

    ; Setting Up Inbound Channel #10
    lda #10             ; Logial File Number
    ldx DEVICE_NUMBER   ; Device Number
    ldy #10             ; Secondary Address
    jsr krljmp_SETLFS$  ; Set Active File Parameters
    lda #1              ; Set Number of Characters
    ldx #<LOCKNM        ; LoByte Address Of String
    ldy #>LOCKNM        ; HiByte Address Of String
    jsr krljmp_SETNAM$  ; Set Parameter for filename
    jmp krljmp_OPEN$    ; Perform Open File Command

;*******************************************************************************
;* Get Character From Channel 10                                               *
;* Input Parameters : None                                                     *
;* Output Parameters : Acc = Character Retreived From Channel                  *
;*******************************************************************************
GetDirectoryCharacter
    ldx #10             ; Set Logical File Number
    jsr krljmp_CHKIN$   ; Set Input Device
    jsr krljmp_CHRIN$   ; Get Character (LoByte Start Address)
    rts

;*******************************************************************************
;* Print U1 Command to Channel 1                                               *
;* Input Parameters : X = Track, Y = Sector                                    *
;* Output Parameters : None                                                    *
;*******************************************************************************
PrintU1Command
    PrintUCommand U1TrackNo, U1SectorNo, U1CommentTXT

U1CommentTXT
    TEXT "u1:10,0,",0
    
;*******************************************************************************
;* Print U2 Command to Channel 1                                               *
;* Input Parameters : X = Track, Y = Sector                                    *
;* Output Parameters : None                                                    *
;*******************************************************************************
PrintU2Command
    PrintUCommand U2TrackNo, U2SectorNo, U2CommentTXT

U2CommentTXT
    TEXT "u2:10,0,",0
    
;*******************************************************************************
;* Print B-P Command to Channel 1                                              *
;* Input Parameters : Acc = Filename Position In Sector                        *
;* Output Parameters : None                                                    *
;*******************************************************************************
PrintBPCommand
    pha                     ; Store Away Acc.
    sta BPPosition
    ldx #1                  ; Load Logial File Number
    jsr krljmp_CHKOUT$      ; Sets Output Device
    lda #<BPCommentTXT      ; Load LoByte DOS Buffer Address
    ldy #>BPCommentTXT      ; Load HiByte DOS Buffer Address
    jsr bas_PrintString$    ; Print String @ Acc, Y
    lda #0
    ldx BPPosition
    jsr bas_DecimalPrint$
    jsr krljmp_CLRCHN$      ; Clear Channel
    pla                     ; Bring Back Acc
    rts

BPCommentTXT
    TEXT "b-p:10,",0
    
;*******************************************************************************
;* CloseAllFileNumbersForLockUnlockSystem                                      *
;* Input Parameters : None                                                     *
;* Output Parameters : None                                                    *
;*******************************************************************************
CloseAllFileNumbersForLockUnlockSystem
    jsr krljmp_CLRCHN$  ; Clear Channel
    lda #1              ; Load Logial File Number 1
    jsr krljmp_CLOSE$   ; Close Logical File Number
    lda #10             ; Load Logial File Number 10
    jmp krljmp_CLOSE$   ; Close Logical File Number
    

