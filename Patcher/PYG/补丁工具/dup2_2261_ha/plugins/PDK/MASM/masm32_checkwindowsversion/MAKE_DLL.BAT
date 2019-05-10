
echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp checkwindowsversion.asm
\masm32\bin\link /RELEASE /DLL /DEF:checkwindowsversion.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib checkwindowsversion.obj resource.res

del checkwindowsversion.obj
del checkwindowsversion.exp
del checkwindowsversion.lib


move *.dll "..\..\..\"

pause