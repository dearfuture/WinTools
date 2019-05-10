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
	LOCAL local_src_filepath[1024]	:BYTE
	LOCAL local_dest_filepath[1024]	:BYTE
	
	
	mov esi,_plugin_data
	
	mov local_return_value,FALSE

	fn AddMsg,"[移动文件]"


	fn ExpandEnvironmentStrings,addr [esi].MY_PLUGIN_DATA_STRUCTURE.src_filepath,addr local_src_filepath,sizeof local_src_filepath			;expand internal vars
	fn ExpandEnvironmentStrings,addr [esi].MY_PLUGIN_DATA_STRUCTURE.dest_filepath,addr local_dest_filepath,sizeof local_dest_filepath		;expand internal vars
	

	fn AddMsg,addr local_src_filepath
	fn AddMsg,addr local_dest_filepath
	
	mov ecx,[esi].MY_PLUGIN_DATA_STRUCTURE.movefileex_flags
	or ecx,MOVEFILE_WRITE_THROUGH	;wait until file is moved
	or ecx,MOVEFILE_COPY_ALLOWED	;allow moving to other drive
	
	
	
	fn MoveFileEx,addr local_src_filepath,addr local_dest_filepath,ecx
	.if eax
		fn AddMsg,"...文件已被移动!"
		mov local_return_value,TRUE
	.else
		fn AddMsg,"...无法移动该文件!"
	.endif

	
	;---This return value is for the "[Event]" Module---
	mov eax,local_return_value	;TRUE or FALSE
	ret	
PLUGIN_Action endp


end DllEntry
