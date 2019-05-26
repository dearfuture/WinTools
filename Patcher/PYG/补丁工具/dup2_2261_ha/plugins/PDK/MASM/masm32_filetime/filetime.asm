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
BTN_SAVE			equ 101
BTN_CANCEL			equ 102
DROPDOWN_TYPE			equ 103
DLG_VAR_NAME			equ 104
DLG_FILENAME			equ 105
CHK_CREATIONTIME		equ 106
CHK_LASTACCESSTIME		equ 107
CHK_LASTWRITETIME		equ 108
BTN_LOAD			equ 109

.data?
hinst				dd ?
hDialogPlugin			dd ?
hwnd_dup2main			dd ?
current_plugin_data		dd ?

hDROPDOWN_TYPE			dd ?


module_description		db 512 dup (?)



.data
pinfo				PLUGIN_INFO <DUP2_PLUGIN_VERSION,"com.d2k2.filetime","[文件时间]","filetime.d2p">





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
	
	;---plugin data is not filled ?---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options == 0
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_GET_FILETIME
		
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_CREATIONTIME
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_LASTACCESSTIME
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_LASTWRITETIME
		
	.endif
	
	
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_GET_FILETIME
		mov ebx,chr$("获取文件时间")
	.else
		mov ebx,chr$("设置文件时间")
	.endif
	
	
	lea edi,[esi].MY_PLUGIN_DATA_STRUCTURE.filepath
	lea edx,[esi].MY_PLUGIN_DATA_STRUCTURE.formatname

	
	.if byte ptr[edx]!=0
	
		.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_GET_FILETIME
			fn wsprintf,addr module_description,chr$("%s -> %s -> %s"),edi,ebx,edx
		.else
			fn wsprintf,addr module_description,chr$("%s -> %s -> %s"),edx,ebx,edi
		.endif		
			
	.endif
	
	mov eax,offset module_description
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
      		
      		
      		;---dropdown match type---
		invoke GetDlgItem,hwnd,DROPDOWN_TYPE
		mov hDROPDOWN_TYPE,eax
	        fn SendMessage,hDROPDOWN_TYPE,CB_ADDSTRING,0,"获取文件时间"
	        fn SendMessage,hDROPDOWN_TYPE,CB_ADDSTRING,0,"设置文件时间"
	        fn SendMessage,hDROPDOWN_TYPE,CB_SETCURSEL,0,0
      		
      		
      		;---tooltip---
      		fn AddToolTip,hwnd,DLG_VAR_NAME,"请在这里用于存储文件时间的环境变量名称!"
	       
		
		;---load plugin data---
		fn LoadPluginData
		
	.elseif eax==WM_COMMAND
		
		mov eax,wparam
		.if 	ax==BTN_CANCEL
			fn SendMessage,hwnd,WM_CLOSE,0,0
			
		.elseif ax==BTN_SAVE
			
			;---save settings before close---
			
			fn GetDlgItemText,hDialogPlugin,DLG_VAR_NAME,addr local_buffer,sizeof local_buffer
			.if eax
				fn SavePluginData
				fn SendMessage,hwnd,WM_CLOSE,0,0
			.else
				fn MessageBox,hDialogPlugin,"请输入一个环境变量名称!",0,MB_ICONEXCLAMATION
			.endif
		
		.elseif ax==BTN_LOAD
		
			fn d2k2_GetFilePath,addr local_buffer,chr$("所有文件",0,"*.*",0,"程序文件 [exe,dll]",0,"*.exe;*.dll",0,0),"c:\",hDialogPlugin
			.if eax
				fn d2k2_FileNameOfPath,addr local_buffer	;returns pointer to filename
				fn SetDlgItemText,hDialogPlugin,DLG_FILENAME,eax
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
	
	
	;---format name---
	fn GetDlgItemText,hDialogPlugin,DLG_VAR_NAME,addr [esi].MY_PLUGIN_DATA_STRUCTURE.formatname,128
	
	;---filename---
	fn GetDlgItemText,hDialogPlugin,DLG_FILENAME,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filepath,1024
	
	
	;--type--
	invoke SendMessage,hDROPDOWN_TYPE,CB_GETCURSEL,0,0
	.if eax==0
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_GET_FILETIME
	.else
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_SET_FILETIME
	.endif	
	
	
	
	;---filetimes---
	fn IsDlgButtonChecked,hDialogPlugin,CHK_CREATIONTIME
	.if eax==BST_CHECKED
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_CREATIONTIME
	.endif
	
	fn IsDlgButtonChecked,hDialogPlugin,CHK_LASTACCESSTIME
	.if eax==BST_CHECKED
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_LASTACCESSTIME
	.endif
	
	fn IsDlgButtonChecked,hDialogPlugin,CHK_LASTWRITETIME
	.if eax==BST_CHECKED
		or [esi].MY_PLUGIN_DATA_STRUCTURE.options,FT_LASTWRITETIME
	.endif
	
	ret
SavePluginData endp


LoadPluginData proc uses esi edi ebx
	
	mov esi,current_plugin_data
	
	
	;---format name---
	fn SetDlgItemText,hDialogPlugin,DLG_VAR_NAME,addr [esi].MY_PLUGIN_DATA_STRUCTURE.formatname
	
	;---filename---
	fn SetDlgItemText,hDialogPlugin,DLG_FILENAME,addr [esi].MY_PLUGIN_DATA_STRUCTURE.filepath
		
	;---type---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_GET_FILETIME
		mov eax,0
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_SET_FILETIME
		mov eax,1
	.endif
	fn SendMessage,hDROPDOWN_TYPE,CB_SETCURSEL,eax,0
	
	
	;---filetimes---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_CREATIONTIME
		fn CheckDlgButton,hDialogPlugin,CHK_CREATIONTIME,BST_CHECKED
	.endif
	
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_LASTACCESSTIME
		fn CheckDlgButton,hDialogPlugin,CHK_LASTACCESSTIME,BST_CHECKED
	.endif
	
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.options & FT_LASTWRITETIME
		fn CheckDlgButton,hDialogPlugin,CHK_LASTWRITETIME,BST_CHECKED
	.endif
	
	ret
LoadPluginData endp


end DllEntry
