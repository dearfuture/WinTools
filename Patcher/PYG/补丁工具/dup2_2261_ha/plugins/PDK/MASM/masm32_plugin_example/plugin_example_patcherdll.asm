;******************************************************************************
;* Example for dUP2 Plugin for MASM 32 Compiler - by diablo2oo2               *
;*                                                                            *
;* this plugin will be attached to to created patcher                         *
;******************************************************************************


.586p
.mmx		
.model flat, stdcall
option casemap :none

;******************************************************************************
;* INCLUDES                                                                   *
;******************************************************************************
include				\masm32\include\windows.inc
include				\masm32\include\user32.inc
include				\masm32\include\kernel32.inc
include				\masm32\include\shell32.inc
include				\masm32\include\advapi32.inc
include				\masm32\include\gdi32.inc
include				\masm32\include\comctl32.inc
include				\masm32\include\comdlg32.inc
include				\masm32\include\msvcrt.inc
include				\masm32\include\masm32.inc
include    			\masm32\macros\ucmacros.asm	;Unicode Macros
include				\masm32\macros\macros.asm

includelib			\masm32\lib\user32.lib
includelib			\masm32\lib\kernel32.lib
includelib			\masm32\lib\shell32.lib
includelib			\masm32\lib\advapi32.lib
includelib			\masm32\lib\gdi32.lib
includelib			\masm32\lib\comctl32.lib
includelib			\masm32\lib\comdlg32.lib
includelib			\masm32\lib\msvcrt.lib
includelib			\masm32\lib\masm32.lib

include				\masm32\include\wsock32.inc
includelib			\masm32\lib\wsock32.lib
include				\masm32\include\wininet.inc
includelib			\masm32\lib\wininet.lib

include 			\masm32\include\ole32.inc
includelib 			\masm32\lib\ole32.lib
include 			\masm32\include\oleaut32.inc
includelib 			\masm32\lib\oleaut32.lib


include 			..\dup2patcher.inc
includelib			..\dup2patcher.lib

include				plugin_data_struct.inc


;******************************************************************************
;* DATA & CONSTANTS                                                           *
;******************************************************************************
.const


.data?
hinst				dd ?


.data




;******************************************************************************
;* CODE                                                                       *
;******************************************************************************
.code

;////////////////////////////////////////////////////////////////////////
;/ The patcher dll is loaded when the patcher window is created (WM_INITDIALOG).
;/ The patcher dll is unloaded when the patcher window is closed (WM_CLOSE).
;////////////////////////////////////////////////////////////////////////
DllEntry proc _hInstance:HINSTANCE, _reason:DWORD, _reserved:DWORD
	
	LOCAL local_temp_folder[1024]:BYTE
	
	.if 	_reason == DLL_PROCESS_ATTACH
		;---on WM_INITDIALOG---
		m2m     hinst, _hInstance

		
	.elseif _reason == DLL_PROCESS_DETACH
		;---on WM_COSE---
	.endif
        
	return TRUE
DllEntry endp



;////////////////////////////////////////////////////////////////////////
;/ PLUGIN_Action is called by the patcher during the patching procedure
;/ PLUGIN_Action must return TRUE if everything went OK, else return FALSE!
;/ return -1 for no result
;////////////////////////////////////////////////////////////////////////
PLUGIN_Action proc uses esi edi ebx _plugin_data
	
	LOCAL local_temp_path[1024]	:BYTE
	LOCAL local_return_value	:DWORD
	
	mov esi,_plugin_data	;you can get the pointer to your plugin data also by GetPluginDataMemory("your.plugin.id.string")
	
	mov local_return_value,FALSE
	
	
	;---post messages to patcher logbox---
	fn AddMsg,"[插件示例]"	;first Message should be the module name
	
	fn AddMsg,"对该文件执行操作:"
	fn AddMsg,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename
	
	
	
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.copy2temp == TRUE
	
		;---we use the "GetFileAttributes" function to check if the file exist---
		fn GetFileAttributes,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename
		.if eax == INVALID_FILE_ATTRIBUTES
			fn AddMsg,"...无法找到该文件!"
		.else
			fn AddMsg,"...正在复制到临时文件夹"
			
			fn GetTempPath,sizeof local_temp_path,addr local_temp_path
			
			fn lstrcat,addr local_temp_path,"\"
			fn lstrcat,addr local_temp_path,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename
			
			fn CopyFile,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename,addr local_temp_path,FALSE
			.if eax
				mov local_return_value,TRUE
			.endif
		.endif
	.endif
	
		
	;---This return value is for the "[Event]" Module---
	mov eax,local_return_value	;TRUE or FALSE
	ret	
PLUGIN_Action endp


end DllEntry
