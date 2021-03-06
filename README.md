# CIDOS : Tutorial 30

## OldSkoolCoder Commodore Integrated Disk Operating System

This repository shows how we can extend the basic commands to allow direct access to the disk systems.

Using these Direct Access BASIC Commands we can Rename, Delete, Copy and many many more operations on the classic Disk Drive systems or the more modern SD2IEC systems.

Enjoy

### List of Command avaliable in CIDOS

The parameters in the command formats are represented as follows :-

* **(filename)** this is a 16 character name for the file requested., e.g. "CIDOS"  
* **(directory)** this is a 16 character name for a directory on the SD2IEC system, e.g. "SOURCECODE"  
* **(dev)** A disk drive drive, e.g. (8,9,10 or 11)  
* **(diskname)** this is a 16 character  name for the disk
* **(id)** this is a unique ID given to the disk, can only be 2 characters e.g. "TA"  
* **(disk image)** is the name of the disk image on the SD2IEC, e.g. "ImageName.d64".  

#### ABOUT
Format : `about` or `a shifted B`

Purpose :	
>This gives a breif description of the system.
 
#### CHAIN
Format : `chain (filename)` or `c shifted H (filename)`

Purpose :  
>To allow the user to save and verify the currently residential BASIC program in memory to Disk.

Example : To save and verify a program

Type :	`CHAIN "CIDOS" <RETURN>`  
Display :  
SAVING CIDOS
SEARCHING FOR CIDOS
VERIFYING
OK
READY

*Result* : if you get an "OK" that means the save and verify performed as expected.

#### SWITCHDIR
Format : `switchdir (directory)` or `s shifted W (directory)`

Purpose :	
>Is to change the directiory on an SD card inserted into the SD2IEC system, this command does not work on the traditional 1541 Disk Drive system.  
>**This is only a SD2IEC Function**  

Example : To change directory to "SOURCECODE"  

Type : `switchdir "SOUCECODE"<RETURN>`  
Display :  
`00, 00, OK, 00`  


*Result* : The code from location C000 to C005 is disassembled. The change is made and then stored with the <RETURN> key. You are left in the assemble mode.

#### COLLECT
Format : `collect` or `c shifted O`  
Purpose :
>This validates and releases any blocks that have not beed allocated within the BAM (Block Allocation Map) system.
> this will then show an increase of blocks avaliable to the user and cleans up the contents.

Example : To collect the disk contents.

Type: `collect <RETURN>`  
*Result* : the potential of blocks been freed up that had become orphaned.

#### COPY
Format : `copy (filename) to (filename)` or `c shifted O (filename) to (filename)`  
Purpose :
>To make a copy of a file on this disk onto this disk with a new file name.

Example : to copy the file "CIDOS" to a new file called "CIDOSOLD"

Type : `copy "CIDOS" to "CIDOSOLD" <RETURN>`  
*Result* : You will have a second copy of the CIDOS file on the disk called CIDOSOLD

#### DEVICE
Format : `device (dev)` or `d shifted E (dev)  
Purpose :
>To allow the user to switch from one disk drive device to another disk drive device if more than one is connected to the Commodore system (VIC20, C64, PET).

Example 1 : TO switch beween device 8 to device 9.

Type : `device 9 <RETURN>`  
*Result* : CIDOS will now be talking to Device 9 with all its commands from now on, until DEVICE comment is executed again.

Example 2 : Lets the user know which is the current device been accessed.

Type : `device <RETURN>`  
*Result* : The system will return the device number that which the CIDOS system is currently in communication with..

#### DISMOUNT
Format : `dismount` or `d shifted I`  
Purpose :  
>This will dismount the current disk image provided by the SD2IEC.  
>**This is only a SD2IEC Function**  

#### HEADER
Format : `header (diskname), (id)` or `h shifted E (diskname), (id)`  
Purpose :
>This command performs a format of the disk currently located in the drive or mounted via the SD2IEC system.  

Example : To format a disk with the name of Sourcecode and an id of SC.

Type : `header "sourcecode", sc <RETURN>`  
*Result* : This will format the disk, and give it a name of sourcecode and an id of sc.

#### HELP
Format : `help` or `he shifted L`  
Purpose :
>To display all the commands within the CIDOS system.

#### INITIALISE
Format : `initialise` or `i shifted N`  
Purpose : This is to initialise the disk in the drive, and forces a re-read of the BAM information.

#### KILL
Format : `kill` or `k shilfted I`  
Purpose :
>This de-activates the CIDOS system, and returns it back to factory setup. 

#### LOCK
Format : `lock (filename)` or `l shifted O (filename)`  
Purpose :
>To write protect a file, so that you cannot delete or overwrite the file accidentally.

Example : To lock the file "CIDOS.prg".

Type : `lock “CIDOS.prg” <RETURN>`  
*Result* : This file is now locked, and when you do a catalog, this file will have a '>' against the file entry, signifying it has been locked.

#### MAKEDIR
Format : `makedir (directory)` or `d shifted I (directory)`  
Purpose :
>To create a directory on the SD2IEC system.  
>**This is only a SD2IEC Function**  

Example : to create a directory called "TEMP".

Type : `makedir "temp" <RETURN>`  
*Result* : a new directory has been created on the SD2IEC system.

#### MOUNT
Format : `mount (disk image)` or `m shifted O (disk image)`
Purpose :
>To mount a disk image from within the SD2IEC system and make it react like a disk has been loaded into the drive.

Example : To mount "elite.d64" 

Type : `mount "elite.d64" <RETURN>`  
*Result* : This will now emulated that disk in then disk system.

#### ERASEDIR
Format : `erasedir (directory)` or `e shifted R (directory)`  
Purpose :
>To delete a directory on the SD2IEC system.  
>**This is only a SD2IEC Function**  

Example : to delete a directory called "TEMP".

Type : `erasedir "temp" <RETURN>`  
*Result* : this directory will have been deleted from the SD2IEC system.

#### RENAME
Format : `rename (filename) to (filename)` or `r shifted E (filename) to (filename)`  
Purpose :
>To rename a file on this disk with a new file name.

Example : to rename the file "CIDOS" to a new file called "CIDOSNEW"

Type : `rename "CIDOS" to "CIDOSNEW" <RETURN>`  
*Result* : You will have renamed the orginal file to be called CIDOSNEW.

#### ROOTDIR
Format : `rootdir` or `r shifted O`  
Purpose :
>To put the SD2IEC system back to the ROOT directory.  
>**This is only a SD2IEC Function**  

Example : to jump to the root directory.

Type : `rootdir <RETURN>`  
*Result* : this puts the SD2IEC systemn back to the Root directory.

#### SCRATCH
Format : `scratch (filename)` or `s shifted C (filename)`  
Purpose :
>To delete a file off the disk drive.

Example : To delete the file "CIDOS.prg".

Type : `scratch “CIDOS.prg” <RETURN>`  
*Result* : This file will no longer be located on this disk.

#### STATUS
Format : `status` or `s shilfted T`  
Purpose :
>This will return the current status of the disk drive system. 

#### UNLOCK
Format : `unlock (filename)` or `u shifted N (filename)`  
Purpose :
>This removes the write protection of a file, so that you can now delete or overwrite the file if required.

Example : To unlock the file "CIDOS.prg".

Type : `unlock “CIDOS.prg” <RETURN>`  
*Result* : This file is now unlocked, and when you do a catalog, this file will nolonger have a '>' against the file entry, signifying it has been unlocked.

## Error Codes
**Invalid Device Number** : signifies that you have entered an incorrect number for the device number, the only allowed device numbers are : 8, 9, 10 and 11

**Save Verify Mismatch** : this signifies that the newly saved file did not match what is currently in memory, and therefore requires a new safe to be performed

**Device Not Ready** : this signifies that the current disk drive is not ready to recieve instructions.
