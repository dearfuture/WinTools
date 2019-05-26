
echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp filetime.asm
\masm32\bin\link /RELEASE /DLL /DEF:filetime.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib filetime.obj resource.res

del filetime.obj
del filetime.exp
del filetime.lib


move *.dll "..\..\..\"

pause