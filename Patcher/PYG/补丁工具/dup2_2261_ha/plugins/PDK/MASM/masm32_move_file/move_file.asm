;******************************************************************************
;* Example for dUP2 Plugin for MASM 32 Compiler                               *
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


include 			..\dup2.inc
includelib			..\dup2.lib

include				plugin_data_struct.inc



;******************************************************************************
;* Custom Functions                                                           *
;******************************************************************************
DialogPlugin			PROTO :DWORD,:DWORD,:DWORD,:DWORD
SavePluginData			PROTO
LoadPluginData			PROTO





;******************************************************************************
;* DATA & CONSTANTS                                                           *
;******************************************************************************
.const

;---Dialog Controls---
BTN_CANCEL			equ 101
BTN_SAVE			equ 102

DLG_SRC_FILE			equ 103
DLG_DEST_FILE			equ 104

CHK_REPLACE_EXISTING		equ 105

.data?
hinst				dd ?
hDialogPlugin			dd ?
hwnd_dup2main			dd ?
current_plugin_data		dd ?


.data
pinfo				PLUGIN_INFO <DUP2_PLUGIN_VERSION,"com.d2k2.move_file","[移动文件]","move_file.d2p">





;******************************************************************************
;* CODE                                                                       *
;******************************************************************************
.code

DllEntry proc _hInstance:HINSTANCE, _reason:DWORD, _reserved:DWORD
	
	.if _reason == DLL_PROCESS_ATTACH
		m2m     hinst, _hInstance
	.endif
        
	return  TRUE
DllEntry endp



;////////////////////////////////////////////////////////////////////////
;/ DUP2_PluginInfo is called when the plugin is loaded.
;/
;/ The function returns a pointer to the PLUGIN_INFO strucure which
;/ contains some important information about the plugin
;////////////////////////////////////////////////////////////////////////
DUP2_PluginInfo proc

	return offset pinfo
DUP2_PluginInfo endp




;////////////////////////////////////////////////////////////////////////
;/ DUP2_EditPluginData is called when you want to edit the plugin data.
;/
;/ There is no rule how to use the plugin data memory. Its structure is
;/ completely definded by the author of the plugin.
;/ Default size of the plugin data memory is 1024 Byte.
;////////////////////////////////////////////////////////////////////////
DUP2_EditPluginData proc _plugin_data:DWORD

	fn GetDup2MainDialogHandle
	mov hwnd_dup2main,eax
	
	;---save pointer to plugin data---
	m2m current_plugin_data,_plugin_data
	
	
	fn DialogBoxParam,hinst,"DIALOG_PLUGIN",hwnd_dup2main,addr DialogPlugin,0
	
	ret
DUP2_EditPluginData endp




;////////////////////////////////////////////////////////////////////////
;/ DUP2_ModuleDescription is called when dup want show a description
;/ of the plugin data content. 
;/ The function returns a pointer to a string which contains the description
;////////////////////////////////////////////////////////////////////////
DUP2_ModuleDescription proc uses esi edi ebx _plugin_data:DWORD
	
	mov esi,_plugin_data
	
	
	lea eax,[esi].MY_PLUGIN_DATA_STRUCTURE.src_filepath

	ret
DUP2_ModuleDescription endp








;////////////////////////////////////////////////////////////////////////
;/ Custom Plugin Functions...
;////////////////////////////////////////////////////////////////////////

DialogPlugin proc uses ebx esi edi hwnd,message,wparam,lparam
	
	LOCAL local_buffer[1024]	:BYTE
	
	mov eax,message
	.if eax==WM_INITDIALOG
		
		;---save handle of plugin dialog---
		m2m hDialogPlugin,hwnd
		
		
		;---make dialog transparent or hide main dialog (depends on dup settings)---
		fn StartChooseHideMethod,hwnd
		
		;---load window position (use the unique id)---
      		invoke LoadWindowPosition,hwnd,addr pinfo.unique_plugin_id
      		
      		
		;---load plugin data---
		fn LoadPluginData
		
	.elseif eax==WM_COMMAND
		
		mov eax,wparam
		.if 	ax==BTN_CANCEL
			fn SendMessage,hwnd,WM_CLOSE,0,0
			
		.elseif ax==BTN_SAVE
			
			fn GetDlgItemText,hDialogPlugin,DLG_SRC_FILE,addr local_buffer,sizeof local_buffer
			.if eax > 0
				;---save settings before close---
				fn SavePluginData
				fn SendMessage,hwnd,WM_CLOSE,0,0
			.else
				fn MessageBox,hwnd,"请输入来源文件!",0,MB_ICONEXCLAMATION
			.endif	
		.endif
	
	.elseif eax==WM_MOUSEMOVE
		;---move Dialog on clicking anywhere---
      		.if wparam==MK_LBUTTON	;left mouse button pressed?
			fn SendMessage,hwnd,WM_SYSCOMMAND,0F012h,0
		.endif
		
	.elseif eax==WM_CLOSE

		fn EndChooseHideMethod
		
		;---save window position (use the unique id)---
      		fn SaveWindowPosition,hwnd,addr pinfo.unique_plugin_id,POS_NOSIZE
		
		fn EndDialog,hwnd,0
		
	.else
		mov eax,FALSE
		ret
	.endif
	
	mov eax,TRUE
	ret
DialogPlugin endp


SavePluginData proc uses esi edi ebx
	
	;---resize plugin data memory, default size is 1024 byte---
	fn ResizeCurrentPluginDataMemory,sizeof MY_PLUGIN_DATA_STRUCTURE,FALSE
	mov current_plugin_data,eax
	
	mov esi,eax
	

	;---filename---
	fn GetDlgItemText,hDialogPlugin,DLG_SRC_FILE,addr [esi].MY_PLUGIN_DATA_STRUCTURE.src_filepath,1024
	fn GetDlgItemText,hDialogPlugin,DLG_DEST_FILE,addr [esi].MY_PLUGIN_DATA_STRUCTURE.dest_filepath,1024


	;---replace existing---
	fn IsDlgButtonChecked,hDialogPlugin,CHK_REPLACE_EXISTING
	.if eax==BST_CHECKED
		or [esi].MY_PLUGIN_DATA_STRUCTURE.movefileex_flags,MOVEFILE_REPLACE_EXISTING	;dwFlags for MoveFileEx Function
	.endif
	
	
	ret
SavePluginData endp


LoadPluginData proc uses esi edi ebx
	
	mov esi,current_plugin_data
	

	;---filename---
	fn SetDlgItemText,hDialogPlugin,DLG_SRC_FILE,addr [esi].MY_PLUGIN_DATA_STRUCTURE.src_filepath
	fn SetDlgItemText,hDialogPlugin,DLG_DEST_FILE,addr [esi].MY_PLUGIN_DATA_STRUCTURE.dest_filepath
	
	
	;---replace existing---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.movefileex_flags & MOVEFILE_REPLACE_EXISTING		;dwFlags for MoveFileEx Function
		fn CheckDlgButton,hDialogPlugin,CHK_REPLACE_EXISTING,BST_CHECKED
	.endif
	
	
	ret
LoadPluginData endp


end DllEntry
