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


include 			..\dup2patcher.inc
includelib			..\dup2patcher.lib

include				plugin_data_struct.inc


;******************************************************************************
;* DATA & CONSTANTS                                                           *
;******************************************************************************
.const


.data?
hinst				dd ?

osversioninfo			OSVERSIONINFOEX <>
sysinfo				SYSTEM_INFO <>

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
	LOCAL local_detected_os		:DWORD
	
	;fn GetPluginDataMemory,"com.d2k2.checkwindowsversion"
	;mov esi,eax
	mov esi,_plugin_data
	
	mov local_return_value,FALSE
	
	
	;---post messages to patcher logbox---
	fn AddMsg,"[检查 Windows 版本]"	;first Message should be the module name
	
	
	
	
	;---get OS Version----
	mov osversioninfo.dwOSVersionInfoSize,sizeof OSVERSIONINFOEX
	fn GetVersionEx,addr osversioninfo
	
	
	fn GetModuleHandle,"kernel32.dll"
	fn GetProcAddress,eax,"GetNativeSystemInfo"	; minimum xp
	.if eax
		push offset sysinfo
		call eax
	.else
		fn GetSystemInfo,addr sysinfo
	.endif
	
	
	
	
	.if ((osversioninfo.dwMajorVersion==5) && (osversioninfo.dwMinorVersion==0))
		mov eax,OS_WIN2000
		
	.elseif ((osversioninfo.dwMajorVersion==5) && (osversioninfo.dwMinorVersion==1))
		mov eax,OS_WINXP
	
	.elseif ((osversioninfo.dwMajorVersion==5) && (osversioninfo.dwMinorVersion==2))
		
		fn GetSystemMetrics,SM_SERVERR2
		mov edx,eax
		
		.if osversioninfo.wProductType == VER_NT_WORKSTATION
			mov eax,OS_WINXPPROHOME
			
		.elseif osversioninfo.wSuiteMask & 00008000h ;VER_SUITE_WH_SERVER
			mov eax,OS_WINHOMESERVER
			
		.elseif edx == 0
			mov eax,OS_WINSERVER2003
		
		.elseif edx != 0
			mov eax,OS_WINSERVER2003R2
		.endif		
		
	.elseif ((osversioninfo.dwMajorVersion==6) && (osversioninfo.dwMinorVersion==0))
		
		.if osversioninfo.wProductType == VER_NT_WORKSTATION
			mov eax,OS_WINVISTA
		.else	
			mov eax,OS_WINSERVER2008
		.endif	
		
	.elseif ((osversioninfo.dwMajorVersion==6) && (osversioninfo.dwMinorVersion==1))
		
		.if osversioninfo.wProductType == VER_NT_WORKSTATION
			mov eax,OS_WIN7
		.else	
			mov eax,OS_WINSERVER2008R2
		.endif
	
	.elseif ((osversioninfo.dwMajorVersion==6) && (osversioninfo.dwMinorVersion==2))
		
		.if osversioninfo.wProductType == VER_NT_WORKSTATION
			mov eax,OS_WIN8
		.else	
			mov eax,OS_WINSERVER2012
		.endif
		
	.else
		mov eax,0FFFFh
	.endif
	
	mov local_detected_os,eax
	
	
	;---get os string---
	mov edi,offset system_names
	mov ecx,local_detected_os
	.while ecx
		.while byte ptr[edi]!=0
			inc edi
		.endw
		inc edi
		dec ecx
	.endw
	
	fn AddMsg,"已检测到操作系统:"
	fn AddMsg,edi
	.if sysinfo.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64
		fn AddMsg,"x64"
		
	.elseif sysinfo.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL
		fn AddMsg,"x86"
		
	.elseif sysinfo.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_IA64
		fn AddMsg,"Itanium 64 位"	
	.endif
	
	
	
	;---compare---
	mov eax,local_detected_os
	
	.if [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype == OS_MATCH_EXACTLY
			
		.if  al == [esi].MY_PLUGIN_DATA_STRUCTURE.os_version
			mov local_return_value,TRUE
		.endif
	
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype == OS_MATCH_MINIMUM
		
		.if  al >= [esi].MY_PLUGIN_DATA_STRUCTURE.os_version
			mov local_return_value,TRUE
		.endif
	
	.elseif [esi].MY_PLUGIN_DATA_STRUCTURE.matchtype == OS_MATCH_MAXIMUM
		
		.if  al <= [esi].MY_PLUGIN_DATA_STRUCTURE.os_version
			mov local_return_value,TRUE
		.endif
	.endif
	
	
	.if local_return_value == TRUE
	
		;---os cpu architecture---
		movzx eax,[esi].MY_PLUGIN_DATA_STRUCTURE.wProcessorArchitecture
		.if ax != 0FFFFh
			.if ax != sysinfo.wProcessorArchitecture
				mov local_return_value,FALSE
				
				fn AddMsg,"检测到错误的处理器架构"
			.endif	
		.endif
	.else
		fn AddMsg,"检测到错误的操作系统版本"
	.endif
	
	
	;---This return value is for the "[Event]" Module---
	mov eax,local_return_value	;TRUE or FALSE
	ret	
PLUGIN_Action endp


end DllEntry
