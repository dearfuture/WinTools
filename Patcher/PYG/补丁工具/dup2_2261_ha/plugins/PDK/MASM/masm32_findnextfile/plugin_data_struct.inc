;---this is our userdefined plugin data structure---

MY_PLUGIN_DATA_STRUCTURE struct
	filepath		db 1024 dup (?)
	filename		db 1024 dup (?)
	env_var			db 512 dup (?)	;%VAR_NAME% without "%"
	options			DWORD ?
	hmem_list		DWORD ?		;used by patcher only	;resource section must be writeable
	nextitem		DWORD ?		;used by patcher only	;resource section must be writeable
MY_PLUGIN_DATA_STRUCTURE ends



.const
FFF_SCAN_SUBFOLDER	equ 1


.data

			
