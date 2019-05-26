#include <windows.h>
#include "main.h"
#include "resource.h"
#include "../sdk/dup2.h"

HINSTANCE hinst;
HWND hDialogPlugin;
MY_PLUGIN_DATA_STRUCTURE* current_plugin_data;


PLUGIN_INFO example_plugin_info = {
	DUP2_PLUGIN_VERSION,
	"com.d2k2.plugin.example",
	"[插件示例]",
	"plugin_example.d2p"
};


PLUGIN_INFO * __stdcall DUP2_PluginInfo() {
	return &example_plugin_info;
}

void __stdcall  DUP2_EditPluginData(MY_PLUGIN_DATA_STRUCTURE* plugin_data) {
	
	current_plugin_data = plugin_data;
	
	DialogBoxParam(hinst, "DIALOG_PLUGIN",
	               GetDup2MainDialogHandle(),
	               (DLGPROC)DialogPlugin, 0);
}

const char* __stdcall  DUP2_ModuleDescription(MY_PLUGIN_DATA_STRUCTURE* plugin_data) {
	return plugin_data->filename;
}

int  DialogPlugin(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
	char local_buffer[1024];
	
	switch ( message ) {
		case WM_INITDIALOG:
			hDialogPlugin = hwnd;
			StartChooseHideMethod(hwnd);
			LoadWindowPosition(hwnd, "com.d2k2.plugin.example");
			LoadPluginData();
			break;
			
		case WM_COMMAND:
			switch ( LOWORD(wparam) ) {
				case BTN_CANCEL:
					SendMessage(hwnd, WM_CLOSE, 0, 0);
					break;
					
				case BTN_SAVE:
					SavePluginData();
					SendMessage(hwnd, WM_CLOSE, 0, 0);
					break;
					
				case BTN_LOAD:
					if ( d2k2_GetFilePath(local_buffer,
					                      "所有文件\0*.*\0程序文件 [exe,dll]\0*.exe;*.dll\0\0",
					                      "c:\\",
					                      hDialogPlugin) ) {
						SetDlgItemText(hDialogPlugin, DLG_FILE, d2k2_FileNameOfPath(local_buffer));
					}
					break;
			}
			break;
			
		case WM_MOUSEMOVE:
			if ( wparam == MK_LBUTTON )
				SendMessage(hwnd, WM_SYSCOMMAND, 0xF012u, 0);
			break;
			
		case WM_CLOSE:
			EndChooseHideMethod();
			SaveWindowPosition(hwnd, "com.d2k2.plugin.example", POS_NOSIZE);
			EndDialog(hwnd, 0);
			break;
			
		default :
			return FALSE;
	}
	return TRUE;
}

void SavePluginData() {
	current_plugin_data = (MY_PLUGIN_DATA_STRUCTURE*) ResizeCurrentPluginDataMemory(sizeof(MY_PLUGIN_DATA_STRUCTURE), 0);
	GetDlgItemText(hDialogPlugin, DLG_FILE, current_plugin_data->filename, sizeof(current_plugin_data->filename));
	current_plugin_data->copy2temp = (IsDlgButtonChecked(hDialogPlugin, CHK_COPY2TEMP)) ? 1 : 0;
}

void LoadPluginData() {
	SetDlgItemText(hDialogPlugin, DLG_FILE, current_plugin_data->filename);
	CheckDlgButton(hDialogPlugin, CHK_COPY2TEMP, current_plugin_data->copy2temp);
}

BOOL APIENTRY DllMain( HINSTANCE hModule, DWORD reason, LPVOID lpReserved ) {
	switch (reason) {
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			hinst = hModule;
			break;
	}
	return TRUE;
}
