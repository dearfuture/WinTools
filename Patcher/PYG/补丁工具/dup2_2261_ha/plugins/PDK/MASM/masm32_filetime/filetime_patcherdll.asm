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
	
	;LOCAL local_temp_folder[1024]:BYTE
	
	.if _reason == DLL_PROCESS_ATTACH
		m2m     hinst, _hInstance
	.endif
        
	return TRUE
DllEntry endp





;////////////////////////////////////////////////////////////////////////
;/ PLUGIN_Action is called by the patcher during the patching procedure
;/ PLUGIN_Action must return TRUE if everything went OK, else return FALSE!
;////////////////////////////////////////////////////////////////////////
PLUGIN_Action proc uses esi edi ebx _plugin_data
	
	LOCAL local_return_value	:DWORD
	LOCAL local_filepath[1024]	:BYTE
	LOCAL local_hFile		:DWORD
	LOCAL local_buffer[256]		:DWORD
	LOCAL local_buffer2[256]	:DWORD

	mov esi,_plugin_data
	
	mov local_return_value,FALSE

	
	
	;---post messages to patcher logbox---
	fn AddMsg,"[文件时间]"	;first Message should be the module name
	
	
	fn ExpandEnvironmentStrings,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filepath,addr local_filepath,sizeof local_filepath			;expand internal vars
	

	
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_GET_FILETIME
		
		fn AddMsg,"正在读取文件时间..."
		fn AddMsg,addr local_filepath
		
		
		;---read filetime---
		fn CreateFile,addr local_filepath,GENERIC_READ,0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL+FILE_ATTRIBUTE_HIDDEN,0
		mov local_hFile,eax
		.if eax != INVALID_HANDLE_VALUE
			fn GetFileTime,local_hFile,addr [esi].MY_PLUGIN_DATA_STRUCTURE.lpCreationTime,addr [esi].MY_PLUGIN_DATA_STRUCTURE.lpLastAccessTime,addr [esi].MY_PLUGIN_DATA_STRUCTURE.lpLastWriteTime
			fn CloseHandle,local_hFile
			
	
			;---store pointer to memory in environment variable---
			invoke dw2hex,esi,addr local_buffer
			fn SetEnvironmentVariable,addr [esi].MY_PLUGIN_DATA_STRUCTURE.formatname,addr local_buffer ;store filepath into environment variable

			;---done---
			mov local_return_value,TRUE

		.else
			fn AddMsg,"无法访问文件!"
		.endif
		
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_SET_FILETIME
	
		fn AddMsg,"正在写入文件时间..."
		fn AddMsg,addr local_filepath
	
	
		;---get pointer to mem from environment variable---
		fn lstrcpy,addr local_buffer2,"%"
		fn lstrcat,addr local_buffer2,addr [esi].MY_PLUGIN_DATA_STRUCTURE.formatname
		fn lstrcat,addr local_buffer2,"%"
		fn ExpandEnvironmentStrings,addr local_buffer2,addr local_buffer,sizeof local_buffer			;expand internal vars
		
		fn htodw,addr local_buffer	;HexString to DWORD
		mov edi,eax
		invoke GlobalLock,edi
		.if eax!=0
			
			;---set filetime--->
			fn CreateFile,addr local_filepath,GENERIC_READ+GENERIC_WRITE,0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL+FILE_ATTRIBUTE_HIDDEN,0
			mov local_hFile,eax
			.if eax != INVALID_HANDLE_VALUE
			
				.if [edi].MY_PLUGIN_DATA_STRUCTURE.options & FT_CREATIONTIME
					lea eax,[edi].MY_PLUGIN_DATA_STRUCTURE.lpCreationTime
				.else
					mov eax,0
				.endif
				
				.if [edi].MY_PLUGIN_DATA_STRUCTURE.options & FT_LASTACCESSTIME
					lea ecx,[edi].MY_PLUGIN_DATA_STRUCTURE.lpLastAccessTime
				.else
					mov ecx,0
				.endif
				
				.if [edi].MY_PLUGIN_DATA_STRUCTURE.options & FT_LASTWRITETIME
					lea edx,[edi].MY_PLUGIN_DATA_STRUCTURE.lpLastWriteTime
				.else
					mov edx,0
				.endif
				
				
				fn SetFileTime,local_hFile,eax,ecx,edx
				fn CloseHandle,local_hFile
				
				;---done---
				mov local_return_value,TRUE
			.else
				fn AddMsg,"无法访问文件!"	
			.endif
			
			
			fn GlobalUnlock,edi
		.endif	
	.endif
	
	
	
	
	;---This return value is for the "[Event]" Module---
	mov eax,local_return_value	;TRUE or FALSE
	ret	
PLUGIN_Action endp

end DllEntry
