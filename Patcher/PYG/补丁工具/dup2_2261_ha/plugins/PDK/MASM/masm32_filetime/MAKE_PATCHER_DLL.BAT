
echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp filetime_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:filetime_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib filetime_patcherdll.obj

del filetime_patcherdll.obj
del filetime_patcherdll.exp
del filetime_patcherdll.lib


move filetime_patcherdll.dll "..\..\..\filetime.d2p"

pause