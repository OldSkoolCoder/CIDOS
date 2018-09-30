;*******************************************************************************
;* LOCK Filename Routine                                                       *
;* Syntax : LOCK or lo shifted C 'File Name'                                   *
;*******************************************************************************
LOCKFILE
    lda #"L"                ; Lock Command
    sta LOCK_UNLOCK_COMMAND ; Store in Command Variable
    jmp ProcessLockUnlockCommand

