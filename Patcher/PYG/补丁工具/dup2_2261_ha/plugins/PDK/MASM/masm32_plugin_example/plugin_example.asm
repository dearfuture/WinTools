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
DLG_FILE			equ 101
BTN_LOAD			equ 102
CHK_COPY2TEMP			equ 103
BTN_CANCEL			equ 104
BTN_SAVE			equ 105


.data?
hinst				dd ?
hDialogPlugin			dd ?
hwnd_dup2main			dd ?
current_plugin_data		dd ?

.data
example_plugin_info		PLUGIN_INFO <DUP2_PLUGIN_VERSION,"com.d2k2.plugin.example","[���ʾ��]","plugin_example.d2p">





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
	return offset example_plugin_info
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
DUP2_ModuleDescription proc _plugin_data:DWORD
	
	;---return pointer to filename string---
	mov edx,_plugin_data
	lea eax,[edx].MY_PLUGIN_DATA_STRUCTURE.filename
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
      		invoke LoadWindowPosition,hwnd,addr example_plugin_info.unique_plugin_id
      		
      		;---tool tip text---
		fn AddToolTip,hwnd,DLG_FILE,"Ŀ���ļ�"
		
		;---load plugin data---
		fn LoadPluginData
		
	.elseif eax==WM_COMMAND
		
		mov eax,wparam
		.if 	ax==BTN_CANCEL
			fn SendMessage,hwnd,WM_CLOSE,0,0
			
		.elseif ax==BTN_SAVE
			
			;---save settings before close---
			fn SavePluginData
			
			fn SendMessage,hwnd,WM_CLOSE,0,0
			
		.elseif ax==BTN_LOAD
		
			fn d2k2_GetFilePath,addr local_buffer,chr$("�����ļ�",0,"*.*",0,"�����ļ� [exe,dll]",0,"*.exe;*.dll",0,0),"c:\",hDialogPlugin
			.if eax
				fn d2k2_FileNameOfPath,addr local_buffer	;returns pointer to filename
				fn SetDlgItemText,hDialogPlugin,DLG_FILE,eax
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
      		fn SaveWindowPosition,hwnd,addr example_plugin_info.unique_plugin_id,POS_NOSIZE
		
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
	fn GetDlgItemText,hDialogPlugin,DLG_FILE,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename,sizeof MY_PLUGIN_DATA_STRUCTURE.filename
	
	
	;---checkbox settings---
	fn IsDlgButtonChecked,hDialogPlugin,CHK_COPY2TEMP
	.if eax==BST_CHECKED
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.copy2temp,TRUE
	.else
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.copy2temp,FALSE
	.endif
	
	ret
SavePluginData endp


LoadPluginData proc uses esi edi ebx
	
	mov esi,current_plugin_data
	
	;---filename---
	fn SetDlgItemText,hDialogPlugin,DLG_FILE,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filename
	
	
	;---checkbox settings---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.copy2temp == TRUE
		fn CheckDlgButton,hDialogPlugin,CHK_COPY2TEMP,BST_CHECKED
	.endif
		
	ret
LoadPluginData endp


end DllEntry
