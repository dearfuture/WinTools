;---this is our userdefined plugin data structure---

MY_PLUGIN_DATA_STRUCTURE struct
	formatname		db 128 dup (?)	;used for environtmentvariable
	filepath		db 1024 dup (?)
	options			DWORD ?	
	lpCreationTime		FILETIME <>
	lpLastAccessTime	FILETIME <>
	lpLastWriteTime		FILETIME <>
MY_PLUGIN_DATA_STRUCTURE ends



.const
FT_GET_FILETIME			equ 1
FT_SET_FILETIME			equ 2

FT_CREATIONTIME			equ 4
FT_LASTACCESSTIME		equ 8
FT_LASTWRITETIME		equ 16


.data

			
