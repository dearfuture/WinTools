
echo *** compiling plugin for patcher***

\masm32\bin\ml /c /coff /Cp log_message_patcherdll.asm
\masm32\bin\link /RELEASE /DLL /DEF:log_message_patcherdll.def /SUBSYSTEM:WINDOWS,5.0 /LIBPATH:\masm32\lib log_message_patcherdll.obj

del log_message_patcherdll.obj
del log_message_patcherdll.exp
del log_message_patcherdll.lib


move log_message_patcherdll.dll "..\..\..\log_message.d2p"

pause