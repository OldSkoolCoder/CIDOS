;*******************************************************************************
;* Chain Routine                                                               *
;* Syntax : Chain or c shifted H 'filename'                                    *
;*            or to over write old file then '@:filename'                      *
;*******************************************************************************

CHAIN
    ldy #0              ; Load Buffer Y Index

    CHRGETSpaceCheck 255    ; Allow spaces to be read
    GetFilenameFromCommandLine DosCommandBuffer
    CHRGETSpaceCheck CHR_Space

    sty FREERAMLAST         ; Store Buffer Index Y Temporarily
    lda DosCommandBuffer+1  ; load Buffer +1
    cmp #CHR_Colon          ; is it a ':'
    bne @StartChainProcess  ; no, then continue
    jsr @ScratchOldFile     ; yes, do chain dos command

@StartChainProcess
    lda #8              ; Load the channel number
    ldx DEVICE_NUMBER   ; load the device number
    ldy #1              ; load the command value
    jsr krljmp_SETLFS$  ; Set the drive parameters

    lda FREERAMLAST     ; Store the Result Temporarily
    ldx #<DosCommandBuffer  ; Load LoByte DOS Buffer Address
    ldy #>DosCommandBuffer  ; Load HiByte DOS Buffer Address
    jsr krljmp_SETNAM$  ; Set the Message for the device

    lda #43             ; Points to Zero Page Location for start of BASIC
    ldx 45              ; Load End Basic Program Lo Byte
    ldy 46              ; Load End Basic Program Hi Byte
    jsr krljmp_SAVE$    ; Save Program  
         
    lda #8              ; Prepeare New Filenumber
    ldx DEVICE_NUMBER 
    ldy #0
    jsr krljmp_SETLFS$

    lda FREERAMLAST         ; Set Filename
    ldx #<DosCommandBuffer
    ldy #>DosCommandBuffer
    jsr krljmp_SETNAM$

    lda #1              ; Sets up for Verify
    ldx 43              ; Load Start Basic Program Lo Byte
    ldy 44              ; Load Start Basic Program Hi Byte
    jsr krljmp_LOAD$    ; Verify Saved Program
    jsr krljmp_READST$  ; Read Error Status ST
    and #16             ; Check Status with MisMatch
    bne @ChainError     ; Save and Verified Failed
    ldy #>CHAINOKTEXT
    lda #<CHAINOKTEXT
    jsr bas_PrintString$; Verify was successful
    jmp ready

@ChainError
    ldx #err_SaveVerifyMismatch$
    jmp ErrorHandler

@ScratchOldFile
    lda #CHR_Return             ; Terminate DOS String
    sta DosCommandBuffer,y
    lda #"s"                    ; Specify Scratch Command
    sta DosCommandBuffer
    jsr OpenDiskCommandChannel  ; Opens Disk Command Channel
    ldx #DiskCommandChannelNumber
    jsr krljmp_CHKOUT$  
    ldy #>DosCommandBuffer
    lda #<DosCommandBuffer
    jsr bas_PrintString$        ; Perform Scratch Command
    jsr krljmp_CLRCHN$          ; Clear Channel
    jsr CloseDiskCommandChannel ; Closes the Command Channel

    ldy #0
@RemoveScratchCommand
    lda DosCommandBuffer+2,y
    sta DosCommandBuffer,y
    iny 
    cpy FREERAMLAST
    bne @RemoveScratchCommand

    dec FREERAMLAST             ; Decrease Filename Length
    dec FREERAMLAST             ; Decrease Filename Length
    rts 

CHAINOKTEXT
    BYTE CHR_Return
    TEXT "ok"
    BYTE CHR_Return
    BRK

