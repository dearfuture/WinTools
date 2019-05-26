
echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp findnextfile_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:findnextfile_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib findnextfile_patcherdll.obj

del findnextfile_patcherdll.obj
del findnextfile_patcherdll.exp
del findnextfile_patcherdll.lib


move findnextfile_patcherdll.dll "..\..\..\findnextfile.d2p"

pause