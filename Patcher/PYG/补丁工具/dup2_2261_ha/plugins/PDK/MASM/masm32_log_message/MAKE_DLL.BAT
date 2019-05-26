
echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp log_message.asm
\masm32\bin\link /RELEASE /DLL /DEF:log_message.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib log_message.obj resource.res

del log_message.obj
del log_message.exp
del log_message.lib


move *.dll "..\..\..\"

pause