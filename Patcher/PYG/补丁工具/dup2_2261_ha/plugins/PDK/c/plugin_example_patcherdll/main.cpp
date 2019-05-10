#include <windows.h>

#include "main.h"
#include "../sdk/dup2patcher.h"

HINSTANCE hinst;
MY_PLUGIN_DATA_STRUCTURE* plugin_data;
#define INVALID_FILE_ATTRIBUTES ((DWORD)-1)
/////////////////////////////////////////////////////////////////////////
// PLUGIN_Action is called by the patcher during the patching procedure
// PLUGIN_Action must return TRUE if everything went OK, else return FALSE!
// return -1 for no result
////////////////////////////////////////////////////////////////////////
BOOL __stdcall PLUGIN_Action(MY_PLUGIN_DATA_STRUCTURE* _plugin_data) {
	BOOL local_return_value;
	char local_temp_path[1024];

	local_return_value = 0;
	
	plugin_data = (MY_PLUGIN_DATA_STRUCTURE*) _plugin_data; 	//you can get the pointer to your plugin data also by GetPluginDataMemory("your.plugin.id.string")
		
	AddMsg("[插件示例]");
	AddMsg("对该文件执行操作:");
	AddMsg(plugin_data->filename);
	
	if ( plugin_data->copy2temp == TRUE ) {
		if ( GetFileAttributes(plugin_data->filename) == INVALID_FILE_ATTRIBUTES ) {
			AddMsg("...无法找到该文件!");
		}
		else {
			AddMsg("...正在复制到临时文件夹");
			
			GetTempPath(sizeof(local_temp_path), local_temp_path);
			lstrcat(local_temp_path, "\\");
			lstrcat(local_temp_path, plugin_data->filename);
			if ( CopyFile(plugin_data->filename, local_temp_path, 0) )
				local_return_value = TRUE;
		}
	}


	return local_return_value;
}

////////////////////////////////////////////////////////////////////////
// The patcher dll is loaded when the patcher window is created (WM_INITDIALOG)
// The patcher dll is unloaded when the patcher window is closed (WM_CLOSE)
////////////////////////////////////////////////////////////////////////
BOOL APIENTRY DllMain( HINSTANCE hModule, DWORD reason, LPVOID lpReserved ) {
	switch (reason) {
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
	}
	return TRUE;
}
