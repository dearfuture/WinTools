
echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp plugin_example.asm
\masm32\bin\link /RELEASE /DLL /DEF:plugin_example.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib plugin_example.obj resource.res

del plugin_example.obj
del plugin_example.exp
del plugin_example.lib


move *.dll "..\..\..\"

pause