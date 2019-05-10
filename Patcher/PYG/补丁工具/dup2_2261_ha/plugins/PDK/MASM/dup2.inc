;//////////////////////////////////////////////////////////////////////////////
;/ dUP2 Plugin - inc file for MASM 32 Compiler
;/
;/ created by diablo2oo2
;/
;//////////////////////////////////////////////////////////////////////////////


DUP2_PLUGIN_VERSION			equ 226		;minimum version of dup2.exe supported by this plugin



POS_NOSIZE				equ 1


;//////////////////////////////////////////////////////////////////////////////
;/ Plugin Exports used by dup2.exe
;//////////////////////////////////////////////////////////////////////////////

DUP2_PluginInfo				PROTO					;returns pointer to PLUGIN_INFO structure
DUP2_EditPluginData			PROTO :DWORD				;parameter: pointer to _plugindata, 
DUP2_ModuleDescription			PROTO :DWORD				;parameter: is pointer to _plugindata, returns description string




;//////////////////////////////////////////////////////////////////////////////
;/ PLUGIN_INFO Structure (returned by DUP2_PluginInfo)
;//////////////////////////////////////////////////////////////////////////////

PLUGIN_INFO struct
	plugin_version			DWORD ?		;fill with DUP2_PLUGIN_VERSION constant
	unique_plugin_id		db 128 dup (?)	;unique plugin id string. example: "com.d2k2.plugin.example"
	module_name			db 128 dup (?)	;will be shown in dup2 main dialog. example: "[Plugin Name]
	plugin_dll			db 512 dup (?) 	;name of the plugin library which will be attached to the patcher. example: "myplugin.d2p". DO NOT USE ".DLL" as file extension!
PLUGIN_INFO ends







;//////////////////////////////////////////////////////////////////////////////
;/ Exported Functions of dup2.exe
;//////////////////////////////////////////////////////////////////////////////


;--- this structure is used by "LoadFileToMem" and "CloseLoadedFile" ---
LFILE_INFO struct
	hfile			DWORD ?			;file handle
	filesize		DWORD ?			;size of file
	hfilemapping		DWORD ?			;handle to the created file mapping object
	hviewoffile		DWORD ?			;pointer to buffer where file is loaded
LFILE_INFO ends


;---most important functions---
GetCurrentPluginDataMemory		PROTO				;returns pointer to current plugin data
GetDup2MainDialogHandle			PROTO				;returns handle to dup2 main window
ResizeCurrentPluginDataMemory		PROTO :DWORD,:DWORD		;parameter: size in bytes , keep old data (TRUE,FALSE)
WriteIniString				PROTO :DWORD,:DWORD		;parameter: pointer to keyname string,pointer to string	//writes data to dup2.ini
ReadIniString				PROTO :DWORD,:DWORD		;parameter: pointer to keyname string,pointer to recievebuffer //reads data from dup2.ini
StartChooseHideMethod			PROTO :DWORD			;parameter: handle to plugin window //call this function when plugin dialog is loaded (WM_INITDIALOG)
EndChooseHideMethod			PROTO				;call this function before plugin dialog is closed (for example on WM_CLOSE)
SaveWindowPosition			PROTO :DWORD,:DWORD,:DWORD	;parameter: hwnd (handle to window),variablename in ini file,POS_NOSIZE(->dont save windowsize) or NULL
LoadWindowPosition			PROTO :DWORD,:DWORD		;parameter: hwnd (handle to window),variablename in ini file


;---other functions---
AddToolTip				PROTO :DWORD,:DWORD,:DWORD	;parameter: handle to dialogbox,control id,tooltip text
LoadFileToMem				PROTO :DWORD,:DWORD,:DWORD	;parameter: filename,readonly(TRUE or FALSE),pointer to LFILE_INFO structure // returns first byte of file or NULL
CloseLoadedFile				PROTO :DWORD			;parameter: pointer to LFILE_INFO structure //closes a file loaded with "LoadFileToMem" function
d2k2_GetFilePath			PROTO :DWORD,:DWORD,:DWORD,:DWORD ;opens browse-for-file dialog. example: fn d2k2_GetFilePath,addr recieve_buffer,chr$("All Files",0,"*.*",0,"Program Files [exe,dll]",0,"*.exe;*.dll",0,0),"c:\",hDialogPlugin
d2k2_FileNameOfPath			PROTO :DWORD			;parameter: full path to a file // return value is a pointer to the filename only
d2k2_GetSaveFilePathEx			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	; example: invoke d2k2_GetSaveFilePathEx,addr recieve_buffer,chr$("WildcardRules [*.ini]",0,"*.ini",0,0),addr init_directory,hwnd,chr$("defaultfilename.ini")
Copy2Clipboard				PROTO :DWORD			;parameter: pointer to string //this function copy a text to clipboard
write_disk_file				PROTO :DWORD,:DWORD,:DWORD	;parameter: filename,data,size of data //return number of bytes written
CRC32OfFile				PROTO :DWORD			;parameter: filename //return CRC32 value
MD5OfFile				PROTO :DWORD			;parameter: filename //return pointer to MD5 value (16 Bytes)
OffsetToVA_File				PROTO :DWORD,:DWORD		;parameter: filename,RAW Offset //returns Virtual Address of the PE file
VAToOffset_File				PROTO :DWORD,:DWORD		;parameter: filename,Virtual Address //returns Raw Offset of the PE file
OffsetToVA				PROTO :DWORD,:DWORD		;parameter: pointer to first byte of PE file (MZ signature),RAW Offset //returns Virtual Address of the PE file
OffsetToRVA				PROTO :DWORD,:DWORD		;parameter: pointer to first byte of PE file (MZ signature),RAW Offset //returns Relative Virtual Address of the PE file
VAToOffset				PROTO :DWORD,:DWORD		;parameter: pointer to first byte of PE file (MZ signature),Virtual Address //returns RAW Offset of the PE file
RVAToOffset				PROTO :DWORD,:DWORD		;parameter: pointer to first byte of PE file (MZ signature),Relative Virtual Address //returns RAW Offset of the PE file
IsPEFile				PROTO :DWORD			;parameter: pointer to first byte of PE file (MZ signature) // Returns TRUE if file is a PE file, else FALSE
GetEntryPoint				PROTO :DWORD			;parameter: pointer to first byte of PE file (MZ signature) // Returns Entry Point of the PE File
GetFirstSectionOffset			PROTO :DWORD			;parameter: pointer to first byte of PE file (MZ signature) // Returns pointer to first section of the PE File
GetSectionName				PROTO :DWORD,:DWORD,:DWORD	;parameter: pointer to first byte of PE file (MZ signature),file offset,recieve buffer for the sectionname //return FALSE or pointer to the sectionname
IsHexString				PROTO :DWORD			;parameter: pointer to hexstring //return TRUE or FALSE , hexpattern in format like this "FF00AACC"
IsHexPatternString			PROTO :DWORD			;parameter: pointer to hexstring //return TRUE or FALSE , hexpattern in format like this "FF 00 ?? CC"
IsNumberString				PROTO :DWORD			;parameter: pointer to hexstring //return TRUE or FALSE , checks if string contains only numbers like "1234567890"
IsInString				PROTO :DWORD,:DWORD,:DWORD	;parameter: startposition (1=first byte),pointer to string,pointer to substring //returns position of substring or NULL if not found
HexStringToHexData			PROTO :DWORD,:DWORD		;parameter: pointer to hexstring (like "AA00BBCC"),pointer to outputbuffer
HexDataToHexString			PROTO :DWORD,:DWORD,:DWORD	;parameter: pointer to hex data,pointer to output string,data lenght //
RemoveSubstring				PROTO :DWORD,:DWORD		;parameter: string,substring //removes substring from input string
TrimToPathOnly				PROTO :DWORD			;parameter: full file path // this function removes the filename
CmpMemory				PROTO :DWORD,:DWORD,:DWORD	;parameter: pointer to data1,pointer to data2,lenght of data //returns TRUE if data1 is equal to data2

SetRegString    			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	;parameter: regkey,keypath,valuename,valuecontent,is64bitregistry (TRUE or FALSE)     // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName","aaa",FALSE
GetRegString    			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	;parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegString, addr recievebuffer,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName",FALSE  
SetRegDword     			PROTO :DWORD,:DWORD,:DWORD,:DWORD		;parameter: regkey,keypath,valuename,valuecontent    // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",10 
GetRegDword     			PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD	;parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegDword,addr recievebuffer,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",FALSE  
Reg_Delete_Value 			PROTO :DWORD,:DWORD,:DWORD			;parameter: regkey,keypath,valuename   //example:  fn Reg_Delete_Value,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","KeyName" 

