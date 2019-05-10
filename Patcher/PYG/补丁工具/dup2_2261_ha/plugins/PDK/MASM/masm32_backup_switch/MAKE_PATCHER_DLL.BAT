
echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp backup_switch_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:backup_switch_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib backup_switch_patcherdll.obj

del backup_switch_patcherdll.obj
del backup_switch_patcherdll.exp
del backup_switch_patcherdll.lib


move backup_switch_patcherdll.dll "..\..\..\backup_switch.d2p"

pause