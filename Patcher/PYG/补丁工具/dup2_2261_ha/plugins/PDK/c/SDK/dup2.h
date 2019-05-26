////////////////////////////////////////////////////////////////////////////////
//
// dUP2 Plugin - header file for C/C++ Compiler
//
// 
//
////////////////////////////////////////////////////////////////////////////////


#ifndef _DUP2__H_
#define _DUP2__H_

#ifdef __cplusplus                                                               
extern "C" {                                                                     
#endif                                                                           


#define DUP2_PLUGIN_VERSION 226		                                             // minimum version of dup2.exe supported by this plugin 
#define POS_NOSIZE          1                                                             

/*
* If you want to change the default plugin data, then you have to undef, then
* redefine it.
* See the example from SDK for mor info.
* 
*/

//////////////////////////////////////////////////////////////////////////////// 
// PLUGIN_INFO Structure (returned by DUP2_PluginInfo)                           
//////////////////////////////////////////////////////////////////////////////// 

typedef struct PLUGIN_INFO {                                                     
	DWORD plugin_version;                                                       // fill with DUP2_PLUGIN_VERSION constant 
   	char unique_plugin_id[128];                                                 // unique plugin id string. example: "com.d2k2.plugin.example" 
   	char module_name[128];                                                      // will be shown in dup2 main dialog. example: "[Plugin Name] 
  	char plugin_dll[512];                                                       // name of the plugin library which will be attached to the patcher. example: "myplugin.d2p". DO NOT USE ".DLL" as file extension! 
} PLUGIN_INFO, *LPPLUGIN_INFO;                                                   




// this structure is used by "LoadFileToMem" and "CloseLoadedFile"
typedef struct LFILE_INFO {                                                      
	HANDLE	hfile;			// file handle
	int 	filesize;		// size of file
	HANDLE	hfilemapping;		// handle to the created file mapping object
	LPVOID  hviewoffile;		// pointer to buffer where file is loaded
} PLFILE_INFO, *PPLFILE_INFO;                                                    




//////////////////////////////////////////////////////////////////////////////// 
// Plugin Exports used by dup2.exe                                               
//////////////////////////////////////////////////////////////////////////////// 

LPPLUGIN_INFO __stdcall DUP2_PluginInfo();                			// returns pointer to PLUGIN_INFO structure 
void __stdcall DUP2_EditPluginData(LPVOID);               			// parameter: pointer to _plugindata,  
const char* __stdcall DUP2_ModuleDescription(LPVOID);            		// parameter: is pointer to _plugindata, returns description string 




///////////////////////////////////////////////////////////////////////
// Exported Functions of dup2.exe                                      
///////////////////////////////////////////////////////////////////////

//---most important functions---                                       
void* __stdcall GetCurrentPluginDataMemory();                                    // returns pointer to current plugin data 
HWND __stdcall GetDup2MainDialogHandle();                                       // returns handle to dup2 main window 
void* __stdcall ResizeCurrentPluginDataMemory(ULONG, BOOL);                      // parameter: size in bytes , keep old data (TRUE,FALSE) 
void __stdcall WriteIniString(LPSTR, LPSTR);                      		// parameter: pointer to keyname string,pointer to string	//writes data to dup2.ini 
void __stdcall ReadIniString(LPSTR, LPSTR);                                     // parameter: pointer to keyname string,pointer to recievebuffer //reads data from dup2.ini 
void __stdcall StartChooseHideMethod(HWND);                                     // parameter: handle to plugin window //call this function when plugin dialog is loaded (WM_INITDIALOG) 
void __stdcall EndChooseHideMethod();                                           // call this function before plugin dialog is closed (for example on WM_CLOSE) 
void __stdcall SaveWindowPosition(HWND, LPSTR, DWORD);                     	// parameter: hwnd (handle to window),variablename in ini file,POS_NOSIZE(->dont save windowsize) or NULL 
void __stdcall LoadWindowPosition(HWND, LPSTR);                            	// parameter: hwnd (handle to window),variablename in ini file 

//---other functions---   
void  __stdcall AddToolTip(HWND,int,LPSTR);          				// parameter: handle to dialogbox,control id,tooltip text                                    
BYTE* __stdcall LoadFileToMem(LPSTR, BOOL, PLFILE_INFO);                        // parameter: filename,readonly(TRUE or FALSE),pointer to LFILE_INFO structure // returns pointer first byte of file or NULL 
void  __stdcall CloseLoadedFile(PLFILE_INFO);                                   // parameter: pointer to LFILE_INFO structure //closes a file loaded with "LoadFileToMem" function 
BOOL  __stdcall d2k2_GetFilePath(LPSTR, LPSTR, LPSTR, HWND);                    // ;opens browse-for-file dialog. example: fn d2k2_GetFilePath,addr recieve_buffer,chr$("All Files",0,"*.*",0,"Program Files [exe,dll]",0,"*.exe;*.dll",0,0),"c:\",hDialogPlugin 
LPSTR __stdcall d2k2_FileNameOfPath(LPSTR);                                     // parameter: full path to a file // return value is a pointer to the filename only 
void  __stdcall d2k2_GetSaveFilePathEx(LPSTR, LPSTR, LPSTR, HWND, LPSTR);       //  example: invoke d2k2_GetSaveFilePathEx,addr recieve_buffer,chr$("WildcardRules [*.ini]",0,"*.ini",0,0),addr init_directory,hwnd,chr$("defaultfilename.ini") 
DWORD __stdcall write_disk_file(LPSTR, void*, DWORD);                           // parameter: filename,data,size of data //return number of bytes written 

void __stdcall Copy2Clipboard(LPSTR);                                           // parameter: pointer to string //this function copy a text to clipboard 

DWORD  __stdcall CRC32OfFile(LPSTR);                                            // parameter: filename //return CRC32 value 
LPBYTE __stdcall MD5OfFile(LPSTR);                                              // parameter: filename //return pointer to MD5 value (16 Bytes) 

DWORD __stdcall OffsetToVA_File(LPSTR, DWORD);                                  // parameter: filename,RAW Offset //returns Virtual Address of the PE file 
DWORD __stdcall VAToOffset_File(LPSTR, DWORD);                                  // parameter: filename,Virtual Address //returns Raw Offset of the PE file 
DWORD __stdcall OffsetToVA(LPBYTE, DWORD);                                      // parameter: pointer to first byte of PE file (MZ signature),RAW Offset //returns Virtual Address of the PE file 
DWORD __stdcall OffsetToRVA(LPBYTE,DWORD);					// parameter: pointer to first byte of PE file (MZ signature),RAW Offset //returns Relative Virtual Address of the PE file
DWORD __stdcall VAToOffset(LPBYTE, DWORD);                                      // parameter: pointer to first byte of PE file (MZ signature),Virtual Address //returns RAW Offset of the PE file 
DWORD __stdcall RVAToOffset(LPBYTE, DWORD);                                     // parameter: pointer to first byte of PE file (MZ signature),Relative Virtual Address //returns RAW Offset of the PE file 

BOOL   __stdcall IsPEFile(LPBYTE);                                              // parameter: pointer to first byte of PE file (MZ signature) // Returns TRUE if file is a PE file, else FALSE 
DWORD  __stdcall GetEntryPoint(LPBYTE);                                         // parameter: pointer to first byte of PE file (MZ signature) // Returns Entry Point of the PE File 
LPVOID __stdcall GetFirstSectionOffset(LPBYTE);                  		// parameter: pointer to first byte of PE file (MZ signature) // Returns pointer to first section of the PE File 
LPVOID __stdcall GetSectionName(LPBYTE, DWORD, LPBYTE);                         // parameter: pointer to first byte of PE file (MZ signature),file offset,recieve buffer for the sectionname //return FALSE or pointer to the sectionname 

BOOL __stdcall IsHexString(LPSTR);                                              // parameter: pointer to hexstring //return TRUE or FALSE , hexpattern in format like this "FF00AACC" 
BOOL __stdcall IsHexPatternString(LPSTR);                                       // parameter: pointer to hexstring //return TRUE or FALSE , hexpattern in format like this "FF 00 ?? CC" 
BOOL __stdcall IsNumberString(LPSTR);                                           // parameter: pointer to hexstring //return TRUE or FALSE , checks if string contains only numbers like "1234567890" 
BOOL __stdcall IsInString(DWORD, LPSTR, LPSTR);                                 // parameter: startposition (1=first byte),pointer to string,pointer to substring //returns position of substring or NULL if not found 
void __stdcall HexStringToHexData(LPSTR, DWORD);                                // parameter: pointer to hexstring (like "AA00BBCC"),pointer to outputbuffer 
void __stdcall HexDataToHexString(LPBYTE, char*, ULONG);                        // parameter: pointer to hex data,pointer to output string,data lenght // 
void __stdcall RemoveSubstring(LPSTR, LPSTR);                                   // parameter: string,substring //removes substring from input string 
void __stdcall TrimToPathOnly(LPSTR);                                           // parameter: full file path // this function removes the filename 
BOOL __stdcall CmpMemory(DWORD, DWORD, DWORD);                                  // parameter: pointer to data1,pointer to data2,lenght of data //returns TRUE if data1 is equal to data2 

void __stdcall SetRegString(DWORD, LPSTR, LPSTR, LPSTR, BOOL);                  // parameter: regkey,keypath,valuename,valuecontent,is64bitregistry (TRUE or FALSE)     // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName","aaa",FALSE 
void __stdcall GetRegString(char*, DWORD, LPSTR, LPSTR, BOOL);                  // parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegString, addr recievebuffer,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","StringKeyName",FALSE   
void __stdcall SetRegDword(DWORD, LPSTR, LPSTR, DWORD);                         // parameter: regkey,keypath,valuename,valuecontent    // example :fn SetRegString, HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",10  
void __stdcall GetRegDword(DWORD, LPSTR, LPSTR, DWORD, BOOL);                   // parameter: recievebuffer,regkey,keypath,valuename,is64bitregistry (TRUE or FALSE)    //example: fn GetRegDword,addr dwValue,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","DwordKeyName",FALSE   

DWORD __stdcall Reg_Delete_Value(DWORD, LPSTR, LPSTR);                          // parameter: regkey,keypath,valuename   //example:  fn Reg_Delete_Value,HKEY_LOCAL_MACHINE,"Software\MASM\Registry Test\","KeyName"  

#ifdef __cplusplus
}
#endif

#endif // _DUP2__H_