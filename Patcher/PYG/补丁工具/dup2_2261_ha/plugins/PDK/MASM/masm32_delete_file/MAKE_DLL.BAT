set file=delete_file

echo *** compiling plugin for dup2.exe ***

\masm32\bin\ml /c /coff /Cp %file%.asm
\masm32\bin\link /RELEASE /DLL /DEF:%file%.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib %file%.obj resource.res

del %file%.obj
del %file%.exp
del %file%.lib


move *.dll "..\..\..\"

pause