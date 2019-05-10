
echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp findnextfile.asm
\masm32\bin\link /RELEASE /DLL /DEF:findnextfile.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib findnextfile.obj resource.res

del findnextfile.obj
del findnextfile.exp
del findnextfile.lib


move *.dll "..\..\..\"

pause