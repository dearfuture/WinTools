
echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp backup_switch.asm
\masm32\bin\link /RELEASE /DLL /DEF:backup_switch.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib backup_switch.obj resource.res

del backup_switch.obj
del backup_switch.exp
del backup_switch.lib


move *.dll "..\..\..\"

pause