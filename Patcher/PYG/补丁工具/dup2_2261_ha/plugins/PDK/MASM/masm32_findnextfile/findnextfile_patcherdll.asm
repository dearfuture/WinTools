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
FILELIST_MEM_SIZE			equ 1024*1024

.data?
hinst				dd ?


.data




;******************************************************************************
;* CODE                                                                       *
;******************************************************************************
.code




MakeFileList proc uses esi edi ebx _filepath,_filename,_subfolder,_list
	
	LOCAL local_finddata		:WIN32_FIND_DATA
	LOCAL local_hfind		:DWORD
	LOCAL local_subfolder[1024]	:BYTE
	
	LOCAL local_fullsearchfilter[1024]:BYTE

	
	
	;---add "\" to end if necessary---
	mov ebx,_filepath
	fn lstrlen,ebx
	.if byte ptr [ebx+eax-1]!="\"
		fn lstrcat,ebx,"\"
	.endif
	
	
	fn lstrcpy,addr local_fullsearchfilter,_filepath
	
	
	.if _subfolder == TRUE
		fn lstrcat,addr local_fullsearchfilter,"*.*"
	.else
		fn lstrcat,addr local_fullsearchfilter,_filename
	.endif	
	
	
	
	fn FindFirstFile,addr local_fullsearchfilter,addr local_finddata
	.if eax!=INVALID_HANDLE_VALUE
		mov local_hfind,eax
		
		.while eax
			
			.if byte ptr local_finddata.cFileName!="."	;ignore this
				
				;---is a folder?---
				.if local_finddata.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY
					.if _subfolder == TRUE
						fn lstrcpy,addr local_subfolder,_filepath
						fn lstrcat,addr local_subfolder,addr local_finddata.cFileName
						
						.if _subfolder == TRUE
							fn MakeFileList,addr local_subfolder,_filename,_subfolder,_list
						.endif	
						fn MakeFileList,addr local_subfolder,_filename,FALSE,_list
					.endif	
				.else
					
					.if _subfolder == FALSE
;						mov eax,_list
;						.if byte ptr[eax]==0
;							fn lstrcpy,_list,_filepath
;						.else	
;							fn lstrcat,_list,_filepath
;						.endif
						fn lstrcat,_list,_filepath
						fn lstrcat,_list,addr local_finddata.cFileName
						fn lstrcat,_list,chr$(13,10)
						
					.endif

				.endif
				
			.endif
			
			fn FindNextFile,local_hfind,addr local_finddata
		.endw
		
		invoke FindClose,local_hfind
	.endif
		
	ret
MakeFileList endp


filelist_readline proc uses esi edi ebx _linenumber,_filelist,_outputbuffer
	
	mov esi,_filelist
	mov ecx,_linenumber
	
	
	;---get line---
	.while ecx
		;---next line
		.while byte ptr[esi]!=13
			
			.break .if byte ptr[esi]==0
			
			inc esi
		.endw
		add esi,2
		
		.break .if byte ptr[esi]==0
		

		dec ecx
	.endw
	
	.if byte ptr[esi]!=0
	
		;---copy content from line to output buffer---
		mov edi,_outputbuffer
		xor ecx,ecx
		.while byte ptr[esi]!=13
			lodsb
			stosb
			inc ecx
			.break .if byte ptr[esi]==0
		.endw
		mov al,0
		stosb
		
		mov eax,ecx	;return number of bytes copied
	.else
		xor eax,eax
	.endif	
	
	ret
filelist_readline endp



;////////////////////////////////////////////////////////////////////////
;/ The patcher dll is loaded when the patcher window is created (WM_INITDIALOG).
;/ The patcher dll is unloaded when the patcher window is closed (WM_CLOSE).
;////////////////////////////////////////////////////////////////////////
DllEntry proc _hInstance:HINSTANCE, _reason:DWORD, _reserved:DWORD
	
	;LOCAL local_temp_folder[1024]:BYTE
	
	.if _reason == DLL_PROCESS_ATTACH
		m2m     hinst, _hInstance
		
	.elseif _reason ==DLL_PROCESS_DETACH

		
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
	LOCAL local_filename[1024]	:BYTE
	LOCAL local_buffer[1024]	:BYTE

	LOCAl local_itemnumber		:DWORD
	
	
	
	mov esi,_plugin_data
	
	mov local_return_value,FALSE

		
	;---post messages to patcher logbox---
	fn AddMsg,"[²éÕÒÎÄ¼þ]"	;first Message should be the module name
	
	
	fn ExpandEnvironmentStrings,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filepath,addr local_filepath,sizeof local_filepath			;expand internal vars
	fn ExpandEnvironmentStrings,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename,addr local_filename,sizeof local_filename			;expand internal vars
	
	
	;---show search filter in logbox---
;	fn lstrcpy,addr local_buffer,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filepath
;	fn lstrcat,addr local_buffer,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename
;	fn AddMsg,addr local_buffer
	
	
	;---is file full file path?---
	lea ebx,local_filepath
	.if byte ptr[ebx+1]!=":"
		fn GetCurrentDirectory,sizeof local_buffer,addr local_buffer
		fn lstrcat,addr local_buffer,"\"
		fn lstrcat,addr local_buffer,addr local_filepath
		fn lstrcpy,addr local_filepath,addr local_buffer
	.endif
	
	
	;---show paths---
	fn AddMsg,addr local_filepath
	fn AddMsg,addr local_filename
	
	
	
	;---get memorylist---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.hmem_list==0
	
		fn VirtualAlloc,0,FILELIST_MEM_SIZE,MEM_COMMIT,PAGE_READWRITE
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.hmem_list,eax	;resource section must be writeable for this action

		
		
		;---make filelist--
		.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FFF_SCAN_SUBFOLDER
			fn MakeFileList,addr local_filepath,addr local_filename,TRUE,[esi].MY_PLUGIN_DATA_STRUCTURE.hmem_list
		.endif
		fn MakeFileList,addr local_filepath,addr local_filename,FALSE,[esi].MY_PLUGIN_DATA_STRUCTURE.hmem_list
		
		
		;---set itemnumber---
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.nextitem,0

		
	.endif
	
	
	
	;---get next item from filelist---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.hmem_list
	

		fn filelist_readline,[esi].MY_PLUGIN_DATA_STRUCTURE.nextitem,[esi].MY_PLUGIN_DATA_STRUCTURE.hmem_list,addr local_buffer
		.if eax
			fn AddMsg,addr local_buffer
			
			fn SetEnvironmentVariable,addr [esi].MY_PLUGIN_DATA_STRUCTURE.env_var,addr local_buffer ;store filepath into environment variable
			
			mov local_return_value,TRUE
		.endif
		
		;---for next plugin call, increase itemnumber---
		inc [esi].MY_PLUGIN_DATA_STRUCTURE.nextitem
	.endif
	
	;---This return value is for the "[Event]" Module---
	mov eax,local_return_value	;TRUE or FALSE
	ret	
PLUGIN_Action endp


end DllEntry
