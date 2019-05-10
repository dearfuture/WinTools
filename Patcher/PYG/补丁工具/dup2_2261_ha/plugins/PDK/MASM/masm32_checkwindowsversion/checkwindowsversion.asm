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
;include    			\masm32\macros\ucmacros.asm	;Unicode Macros
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
DROPDOWN_MATCHTYPE		equ 103
DROPDOWN_OSVERSION		equ 104
CHK_CPU_X86			equ 105
CHK_CPU_X64			equ 106
CHK_CPU_ITANIUM			equ 107
CHK_CPU_ANY			equ 108


.data?
hinst				dd ?
hDialogPlugin			dd ?
hwnd_dup2main			dd ?
current_plugin_data		dd ?

hDROPDOWN_MATCHTYPE		dd ?
hDROPDOWN_OSVERSION		dd ?


module_description		db 512 dup (?)

.data
pinfo				PLUGIN_INFO <DUP2_PLUGIN_VERSION,"com.d2k2.checkwindowsversion","[检查 Windows 版本]","checkwindowsversion.d2p">





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
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype == 0
	
		;---default settings---
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype,OS_MATCH_MINIMUM
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.os_version,OS_WIN2000
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture,0FFFFh ;any
	.endif
	
	
	;---match type---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype == OS_MATCH_MINIMUM
		mov ebx,chr$("大于或等于")
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype == OS_MATCH_MAXIMUM
		mov ebx,chr$("小于或等于")
	.else 
		mov ebx,chr$("必须为")
	.endif
	
	
	;---os name---
	movzx ecx,[esi].MY_PLUGIN_DATA_STRUCTURE.os_version
	mov edi,offset system_names
	
	.while ecx
		.while byte ptr[edi]!=0
			inc edi
		.endw
		inc edi
		dec ecx
	.endw
	
	
	;---cpu---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64
		mov edx,chr$("x64")
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_IA64
		mov edx,chr$("Itanium")
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL
		mov edx,chr$("x86")
	.else
		mov edx,chr$("任意 CPU 架构")	
	.endif
	
	
	
	fn wsprintf,addr module_description,"%s %s - [%s]",ebx,edi,edx
	

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
		invoke GetDlgItem,hwnd,DROPDOWN_MATCHTYPE
		mov hDROPDOWN_MATCHTYPE,eax
	        fn SendMessage,hDROPDOWN_MATCHTYPE,CB_ADDSTRING,0,"等于"
	        fn SendMessage,hDROPDOWN_MATCHTYPE,CB_ADDSTRING,0,"大于或等于"
	        fn SendMessage,hDROPDOWN_MATCHTYPE,CB_ADDSTRING,0,"小于或等于"
	        fn SendMessage,hDROPDOWN_MATCHTYPE,CB_SETCURSEL,0,0
		
		
		;---fill dropdown menu with system names---
		invoke GetDlgItem,hwnd,DROPDOWN_OSVERSION
		mov hDROPDOWN_OSVERSION,eax
		
		mov esi,offset system_names
		
		.while byte ptr[esi]!=0
			fn SendMessage,hDROPDOWN_OSVERSION,CB_ADDSTRING,0,esi
			
			fn lstrlen,esi
			add esi,eax
			add esi,1
		.endw
		fn SendMessage,hDROPDOWN_OSVERSION,CB_SETCURSEL,0,0
	       
		
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
	
	;---match type---
	invoke SendMessage,hDROPDOWN_MATCHTYPE,CB_GETCURSEL,0,0
	inc eax
	mov [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype,al
	
	
	;---os name--
	invoke SendMessage,hDROPDOWN_OSVERSION,CB_GETCURSEL,0,0
	mov [esi].MY_PLUGIN_DATA_STRUCTURE.os_version,al
	
	
	;---cpu architecture---
	fn IsDlgButtonChecked,hDialogPlugin,CHK_CPU_ANY
	.if eax==BST_CHECKED
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture,0FFFFh ;any
	.endif
	
	fn IsDlgButtonChecked,hDialogPlugin,CHK_CPU_ITANIUM
	.if eax==BST_CHECKED
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture,PROCESSOR_ARCHITECTURE_IA64
	.endif
	
	fn IsDlgButtonChecked,hDialogPlugin,CHK_CPU_X64
	.if eax==BST_CHECKED
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture,PROCESSOR_ARCHITECTURE_AMD64
	.endif
	
	fn IsDlgButtonChecked,hDialogPlugin,CHK_CPU_X86
	.if eax==BST_CHECKED
		mov [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture,PROCESSOR_ARCHITECTURE_INTEL
	.endif

	ret
SavePluginData endp


LoadPluginData proc uses esi edi ebx
	
	mov esi,current_plugin_data
	
		
	;---match type---
	movzx eax,[esi].MY_PLUGIN_DATA_STRUCTURE.matchtype
	dec eax
	fn SendMessage,hDROPDOWN_MATCHTYPE,CB_SETCURSEL,eax,0
	
	
	;---os name--
	movzx eax,[esi].MY_PLUGIN_DATA_STRUCTURE.os_version
	fn SendMessage,hDROPDOWN_OSVERSION,CB_SETCURSEL,eax,0
	
	
	;---cpu architecture---
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == 0FFFFh
		mov ebx,CHK_CPU_ANY
		
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL
		mov ebx,CHK_CPU_X86
			
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64
		mov ebx,CHK_CPU_X64
		
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_IA64
		mov ebx,CHK_CPU_ITANIUM			
	.endif
	fn CheckDlgButton,hDialogPlugin,ebx,BST_CHECKED
	
	
	ret
LoadPluginData endp


end DllEntry
