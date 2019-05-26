;---this is our userdefined plugin data structure---

MY_PLUGIN_DATA_STRUCTURE struct
	matchtype		BYTE ?
	os_version		BYTE ?
	wProcessorArchitecture	WORD ?	;PROCESSOR_ARCHITECTURE_AMD64,PROCESSOR_ARCHITECTURE_IA64,PROCESSOR_ARCHITECTURE_INTEL, if 0xFFFF = any
MY_PLUGIN_DATA_STRUCTURE ends



.const
OS_WIN2000		equ 0
OS_WINXP		equ 1
OS_WINXPPROHOME		equ 2
OS_WINSERVER2003	equ 3
OS_WINHOMESERVER	equ 4
OS_WINSERVER2003R2	equ 5
OS_WINVISTA		equ 6
OS_WINSERVER2008	equ 7
OS_WINSERVER2008R2	equ 8
OS_WIN7			equ 9
OS_WINSERVER2012	equ 10
OS_WIN8			equ 11



OS_MATCH_EXACTLY	equ 1
OS_MATCH_MINIMUM	equ 2
OS_MATCH_MAXIMUM	equ 3



.data

system_names		db "Windows 2000 (5.0)",0
			db "Windows XP (5.1)",0
			db "Windows XP Professional or Home (5.2)",0
			db "Windows Server 2003 (5.2)",0			
			db "Windows Home Server (5.2)",0			
			db "Windows Server 2003 R2 (5.2)",0			
			db "Windows Vista (6.0)",0
			db "Windows Server 2008 (6.0)",0
			db "Windows Server 2008 R2 (6.1)",0
			db "Windows 7 (6.1)",0
			db "Windows Server 2012 (6.2)",0
			db "Windows 8 (6.2)",0
			db 0
			
