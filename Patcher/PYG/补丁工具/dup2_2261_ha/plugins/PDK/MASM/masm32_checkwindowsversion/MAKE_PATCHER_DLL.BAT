
echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp checkwindowsversion_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:checkwindowsversion_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib checkwindowsversion_patcherdll.obj

del checkwindowsversion_patcherdll.obj
del checkwindowsversion_patcherdll.exp
del checkwindowsversion_patcherdll.lib


move checkwindowsversion_patcherdll.dll "..\..\..\checkwindowsversion.d2p"

pause