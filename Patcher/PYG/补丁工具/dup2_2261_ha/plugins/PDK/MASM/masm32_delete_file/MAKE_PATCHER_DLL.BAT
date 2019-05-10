set file=delete_file

echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp %file%_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:%file%_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib %file%_patcherdll.obj

del %file%_patcherdll.obj
del %file%_patcherdll.exp
del %file%_patcherdll.lib


move %file%_patcherdll.dll "..\..\..\%file%.d2p"

pause