;*******************************************************************************
;* UNLOCK Filename Routine                                                     *
;* Syntax : UNLOCK or u shifted N 'File Name'                                  *
;*******************************************************************************
UNLOCKFILE
    lda #"U"                ; Lock Command
    sta LOCK_UNLOCK_COMMAND ; Store in Command Variable
    jmp ProcessLockUnlockCommand

