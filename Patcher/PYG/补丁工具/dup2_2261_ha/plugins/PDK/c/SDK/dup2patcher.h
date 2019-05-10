////////////////////////////////////////////////////////////////////////////////
//
// dUP2 Plugin - header file for C/C++ Compiler
//
// created by diablo2oo2
//
////////////////////////////////////////////////////////////////////////////////

#ifndef _DUP2PATCHER__H_
#define _DUP2PATCHER__H_

#ifdef __cplusplus
extern "C" {
#endif


#define OP_READONLY            0x80000000
#define OP_TRYPATCHINGUSEDFILE 2
#define OP_CHECKSUM_FIX        32
#define OP_KEEP_FILE_TIME      16


////////////////////////////////////////////////////////////////////////////////
// Plugin Exports used by the created patcher
////////////////////////////////////////////////////////////////////////////////

BOOL __stdcall PLUGIN_Action(LPVOID);        // paramater: pointer to the plugindata // must return TRUE or FALSE or -1(nothing)


////////////////////////////////////////////////////////////////////////////////
// Exported Functions of the created patcher executable
////////////////////////////////////////////////////////////////////////////////

void* __stdcall GetPluginDataMemory(LPSTR);		                // parameter: plugin id string (see PLUGIN_INFO structure) //returns pointer to plugin data // example GetPluginDataMemory("com.d2k2.plugin.example")

HWND __stdcall GetPatcherWindowHandle();				// returns handle of the patcher window

void __stdcall AddMsg(LPSTR);                                           // paramater: log message string // shows a message in the logbox

BYTE* __stdcall LoadFileMapping(LPSTR, ULONG, DWORD);                   // parameter: filename,new filesize (or NULL),options //return pointer to first byte of file
									// options can be conbination of following:
									// OP_READONLY                 - open file in readonly mode
									// OP_TRYPATCHINGUSEDFILE      - try to open a file which is in use

void __stdcall CloseFileMapping(BOOL, DWORD);                           // parameter: TRUE (if changed something) else FALSE,options
									// options can be conbination of following:
									// OP_CHECKSUM_FIX        - PE CheckSum Fix (for PE files only, like system librarys)
									// OP_KEEP_FILE_TIME      - restores original file time and date

void __stdcall CloseFileMapping_readonly();                                     // use this function instead of CloseFileMapping if file was opened in readonly mode

ULONG __stdcall write_disk_file(LPSTR, void*, DWORD);                           // parameter: filename,data,size of data //return number of bytes written

void __stdcall SetRegString(DWORD, LPSTR, LPSTR, LPSTR, BOOL);                  // parameter: regkey,keypath,valuename,valuecontent,is64bitregistry (TRUE or FALSE)     // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName","aaa",FALSE
void __stdcall GetRegString(char*, DWORD, LPSTR, LPSTR, BOOL);                  // parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegString, addr recievebuffer,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName",FALSE
void __stdcall SetRegDword(DWORD, LPSTR, LPSTR, DWORD);                         // parameter: regkey,keypath,valuename,valuecontent    // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",10
void __stdcall GetRegDword(DWORD, LPSTR, LPSTR, DWORD, BOOL);                   // parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegDword,addr dwValue,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",FALSE   
void __stdcall Reg_Delete_Value(DWORD, LPSTR, LPSTR);                           // parameter: regkey,keypath,valuename   //example:  fn Reg_Delete_Value,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","KeyName"



BOOL __stdcall SearchAndReplace(void*,void*,void*,void*,void*,DWORD ,DWORD ,DWORD);	// return TRUE or FALSE
/*
;**********************************************************************************************
;* Example                                                                                    *
;* ------------------------------------------------------------------------------------------ *
;* search : 2A 45 EB ?? C3 ?? EF                                                              *
;* replace: 2A ?? ?? 10 33 C0 ??                                                              *
;*                                                                                            *
;* .data                                                                                      *
;* SearchPattern   db 02Ah, 045h, 0EBh, 000h, 0C3h, 000h, 0EFh                                *
;* SearchMask      db    0,    0,    0,    1,    0,    1,    0	 ;(1=Ignore Byte)             *
;*                                                                                            *
;* ReplacePattern  db 02Ah, 000h, 000h, 010h, 033h, 0C0h, 000h                                *
;* ReplaceMask     db    0,    1,    1,    0,    0,    0,    1	 ;(1=Ignore Byte)             *
;*                                                                                            *
;* .const                                                                                     *
;* PatternSize     equ 7                                                                      *
;*                                                                                            *
;* .code                                                                                      *
;* push -1                      ;Replace Number (-1=ALL / 2=2nd match ...)                    *
;* push FileSize                ;how many bytes to search from beginning from TargetAdress    *
;* push PatternSize             ;lenght of Pattern                                            *
;* push offset ReplaceMask                                                                    *
;* push offset ReplacePattern                                                                 *
;* push offset SearchMask                                                                     *
;* push offset SearchPattern                                                                  *
;* push TargetAddress           ;the memory address where the search starts                   *
;* call SearchAndReplace                                                                      *
;*                                                                                            *
;* ReturnValue in eax (1=Success 0=Failed)                                                    *
;**********************************************************************************************
*/





#ifdef __cplusplus
}
#endif

#endif // _DUP2PATCHER__H_
