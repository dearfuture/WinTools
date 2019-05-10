
echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp plugin_example_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:plugin_example_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib plugin_example_patcherdll.obj

del plugin_example_patcherdll.obj
del plugin_example_patcherdll.exp
del plugin_example_patcherdll.lib


move plugin_example_patcherdll.dll "..\..\..\plugin_example.d2p"

pause