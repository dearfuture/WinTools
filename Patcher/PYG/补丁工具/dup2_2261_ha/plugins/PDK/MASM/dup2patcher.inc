;//////////////////////////////////////////////////////////////////////////////
;/ dUP2 Plugin - inc file for MASM 32 Compiler
;/
;/ created by diablo2oo2
;/
;//////////////////////////////////////////////////////////////////////////////



OP_READONLY				equ 80000000h
OP_TRYPATCHINGUSEDFILE			equ 2
OP_CHECKSUM_FIX				equ 32
OP_KEEP_FILE_TIME			equ 16




;//////////////////////////////////////////////////////////////////////////////
;/ Plugin Exports used by the created patcher
;//////////////////////////////////////////////////////////////////////////////

PLUGIN_Action 				PROTO :DWORD			;paramater: pointer to the plugindata // must return TRUE or FALSE or -1(nothing)






;//////////////////////////////////////////////////////////////////////////////
;/ Exported Functions of the created patcher executable
;//////////////////////////////////////////////////////////////////////////////

GetPluginDataMemory			PROTO :DWORD			;parameter: plugin id string (see PLUGIN_INFO structure) //returns pointer to plugin data // example GetPluginDataMemory("com.d2k2.plugin.example")

GetPatcherWindowHandle			PROTO				;returns handle of the patcher window

AddMsg					PROTO :DWORD			;paramater: log message string // shows a message in the logbox


LoadFileMapping 			PROTO :DWORD,:DWORD,:DWORD	;parameter: filename,new filesize (or NULL),options //return pointer to first byte of file
	;options can be conbination of following:
	;OP_READONLY			- open file in readonly mode
	;OP_TRYPATCHINGUSEDFILE		- try to open a file which is in use
	


CloseFileMapping			PROTO :DWORD,:DWORD		;parameter: TRUE (if changed something) else FALSE,options
	;options can be conbination of following:
	;OP_CHECKSUM_FIX		- PE CheckSum Fix (for PE files only, like system librarys)
	;OP_KEEP_FILE_TIME		- restores original file time and date


CloseFileMapping_readonly		PROTO				;use this function instead of CloseFileMapping if file was opened in readonly mode


write_disk_file				PROTO :DWORD,:DWORD,:DWORD	;parameter: filename,data,size of data //return number of bytes written


SetRegString    			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	;parameter: regkey,keypath,valuename,valuecontent,is64bitregistry (TRUE or FALSE)     // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName","aaa",FALSE
GetRegString    			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	;parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegString, addr recievebuffer,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName",FALSE  
SetRegDword     			PROTO :DWORD,:DWORD,:DWORD,:DWORD		;parameter: regkey,keypath,valuename,valuecontent    // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",10 
GetRegDword     			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	;parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegDword,addr recievebuffer,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",FALSE  
Reg_Delete_Value 			PROTO :DWORD,:DWORD,:DWORD			;parameter: regkey,keypath,valuename   //example:  fn Reg_Delete_Value,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","KeyName" 




SearchAndReplace 			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD ;returns TRUE or FAlSE
;**********************************************************************************************
;* Example                                                                                    *
;* ------------------------------------------------------------------------------------------ *
;* search : 2A 45 EB ?? C3 ?? EF                                                              *
;* replace: 2A ?? ?? 10 33 C0 ??                                                              *
;*                                                                                            *
;* .data                                                                                      *
;* SearchPattern   db 02Ah, 045h, 0EBh, 000h, 0C3h, 000h, 0EFh                                *
;* SearchMask      db    0,    0,    0,    1,    0,    1,    0	 ;(1=Ignore Byte)             *
;*                                                                                            *
;* ReplacePattern  db 02Ah, 000h, 000h, 010h, 033h, 0C0h, 000h                                *
;* ReplaceMask     db    0,    1,    1,    0,    0,    0,    1	 ;(1=Ignore Byte)             *
;*                                                                                            *
;* .const                                                                                     *
;* PatternSize     equ 7                                                                      *
;*                                                                                            *
;* .code                                                                                      *
;* push -1                      ;Replace Number (-1=ALL / 2=2nd match ...)                    *
;* push FileSize                ;how many bytes to search from beginning from TargetAdress    *
;* push PatternSize             ;lenght of Pattern                                            *
;* push offset ReplaceMask                                                                    *
;* push offset ReplacePattern                                                                 *
;* push offset SearchMask                                                                     *
;* push offset SearchPattern                                                                  *
;* push TargetAddress           ;the memory address where the search starts                   *
;* call SearchAndReplace                                                                      *
;*                                                                                            *
;* ReturnValue in eax (1=Success 0=Failed)                                                    *
;**********************************************************************************************
