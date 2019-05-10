diablo2oo2's Universal Patcher [dUP]
************************************
Version: 2.26.1

Features:
* multiple file patcher
* programmable patch procedure
* offset patcher
* search and replace patcher
* text patcher (regualr expression support)
* registry patcher
* loader generator
* compare files (RawOffset and VirtualAddress) with different filesize
* attach files to patcher
* get filepaths from registry
* CRC32/MD5 and filesize checks
* patching packed files
* compress patcher with your favorite packer
* save/load projects
* use custom skin in your patcher
* add music (Tracker Modules: xm,mod,it,s3m,mtm,umx,v2m,ahx,sid) to patcher
* multilanguage support
* and many more...


Version History
---------------
[2.26.1]
-bugfix in [text patch] module
-bugfix: plugins did not work with "/silent" paramenter
-bugfix: patching used files did not work with "/silent" paramenter

[2.26]
-added large file support for search & replace module
-patchercode now is stored in a DLL
-updated BeaEngine.dll (4.1 rev 172)
-fixed: backup files for [attached file] module
-added new filetime plugin
-added new log message plugin
-added new backup switch plugin
-added new find next file plugin
-fixed: patcher with plugins now can be packed
-new option to run patcher after creation
-new query option in [file check] module: check for write access
-show jump destination of [event] module in patchdata list
-fixed crash when open dUP2 project with large filename
-auto backup unsaved projects
-improved save system
-added some copy/paste shortcuts
-minor fixes

[2.25]
-bugfix: open files in sharemode
-new disassembler engine: BeaEngine
-improved search & replace comparison
-plugin dlls are loaded now on patcher startup
-updated plugin development kit
-added option to turn off backup by default

[2.24]
-improved compatibility for windows 2000
-usage of reg.exe instead of regedit.exe for registry patching
-added regular expressions (PCRE) support to [Text Patch] module
-added regular expressions (PCRE) support to [Registry Check] module
-added new plugin "Check Windows Version"

[2.23]
-fixed music playback bug
-fixed bug: open *.dUP2 files with dup2.exe
-fixed bug: crash when option "do not check original bytes" is enabled
-fixed bug: commandline parameter "/startupworkdir" did not work
-any bytepattern format will be accepted when it is pasted
-added plugin support
-added ASLR support
-added DLL patching support for the loader

[2.22]
-added console output for patcher
-fixed bug in "silent" mode
-fixed bug when using "multi-wildcard-mode"
-new option to fix the CheckSum in PE Header after patching
-more detailed patchlog
-removed "xmstrip"
-added console command (/setvar) for setting %dup2_cmd_var%
-new logo (thank you kr8Vity!)
-new menu structure

[2.21]
-new option to keep original file time and date
-new option to disable the WOW64 File System Redirector (for 64 Bit Patching)
-new option to import multiple file attachments
-new: tooltip for bytepattern shows now also the ASCII text of the bytepattern
-bugfix: inline patching should now also work on windows 7
-bugfix: improved inline patching method
-text patch: single wildcards (?) will not be cut out any longer at end and begin of the 'Find Text'
-added new "Registry Check" module
-improved access to 64 Bit registry (small bugfix)
-improved menu structure of dup2 gui (adding patchdata is now easier) 
-bugfix: crash when open project
-new option for the project: run patch with administrator rights

[2.20]
-added wildcard support for textpatch module
-windowresize bugs fixed
-minimize patcherwindow with rightmouseclick
-added new "Event" module for patcher. Now you can programm your patcher!
-added new "File Check" module for patcher
-bugfixes in textpatch module
-bugfix: executing attached files
-bugfix: problem with nested environment variables
-bugfix: tooltips will be shown without flicker effect on windows 7
-bugfix: increased patternsize limit for search & replace compare module
-fix: remove quotation marks from paths when reading fom registry

[2.19]
-new "Text-Patch" module !
-bugfix in s&r compare module
-other bugfixes from v2.18
-added linkcursor in patcherwindow
-registry editor now can import v5 reg files
-faster scrolltext engine
-better scrolltext font management
-new function: import long hexpatterns in offset-patch-dialog
-fixed loader_installer bug
-added support for relative paths (subfolders) for the targetfiles
-search & replace comments bugfix
-loader: registrypatcher bugfix
-added new internal environment variable: %dup2_last_path%
-skincontrols now can have transparent backgroundcolor (FFFFFFFF)
-now you can execute multiple search&replace loaders from same directory
-improved placholder function for registry patching

[2.18]
-replaced WinExec API by ShellExecute for Windows Vista
-bugfix in Dialog for editing S&R Pattern Occurrence
-added check for skin button IDs
-improved window resizing engine
-added option "trim to path" for Registry Paths
-loader can save now targetfilepath to inifile when its not in same folder
-added TitchySID player for .sid file playback
-added new option for attached files: overwrite existing file
-added support for disabled patch button skin
-added multilanguage support
-fixed bug with tooltip width. long hexpatterns are displayed now in multiple lines
-compiled with new MASM v10
-bugfix when executing attached files
-bugfix for resource (skin) updater
-strings for patcher.exe can be modifed now inside a skin

[2.17]
-improved dup2 plugin for ollydbg v1.10
-long comments for search&replace patchdata now possible
-new v2m player (vista compatible) from http://magic.shabgard.org
-use targetfile information from s&r dialog in CheckOccurrence Dialog
-added function "back to releaseinfo" in patcher logbox
-bug fixed on vista systems with music playback
-"patch" button will be disabled after patching
-some fixes in projectconverter (for old v1.x dup projects)
-changed handling with unresolved environment variables
-original bytes not saved to compiled patcher when "dont't check original bytes" option is enabled
-fixed bug when saving columnswidth of listviews
-new for Attached File: delete file after execute
-new for Attached File: wait for process
-added support for PECompact (optional commandline settings)
-manifest in resource is now avaible by default
-patcher: last used filepath will be stored inside %dup2_last_file% environment variable
-removed the ugly "flicker"-effect on bitmap buttons
-improved dumping (open projects from patcher.exe)
-advanced registry patching (usage of placeholders)
-changes in bitmapbutton code (please only use new button names: BTN_PATCH_OVER ...)
-added fade in/out effect for patcher
-problem with the patchers topmost windows fixed
-removed option from settings dialog: dup file association
-important bugfix in loadercode (patching of protected memory)
-added option for registry patches: resolve environment variables
-fixed bug for musicplayback with bassmod.dll
-added textscroller feature
-fill patchinfdialog with default info only when new project is created

[2.16]
-proceed patchdata in userdefined order
-resizeable dialogs
-autodetect if to hide releaseinfobox in patcher
-patching of used files (using file rename method)
-remove useless wildcards at begin & end from pattern
-updated ufmod player (for XM music) to v1.25
-fixed bug: closing dialogs with ESC key
-multiline comments for s&r patchdata
-added "next" button in settings dialog for finding next song
-removed some items from s&r dialog
-minor bugfixes and code changes

[2.15]
-added search&replace compare module with use of wildcards
-added support for playing *.v2m files
-added support for playing *.ahx files
-updated ufmod player (for XM music) to v1.22
-added replacepattern optimazion
-small bugfix: RCDATA will be skipped in *.res files
-bugfix with resource file handling
-new feature:export attached files from project
-bugfix for loader-installer creation
-custom icon will be also applied on loader installer
-added HexEditor feature (16Edit) in some dialogs
-center about dialog in patcher
-added new dialog for editing "Registry Path" data
-changed control order in settings dialog
-new exception error dialog
-fixed bug in search&replace loader
-loaderinstaller will be packed too now
-new attachment feature: execute attachment with commandlineparameters
-new attachment feature: select exportpath
-added support for bitmap buttons (up,down,over)
-dialogs can be closed with ESC key
-minor changes

[2.14]
-open project from compiled patcher/loader
-copy offset-data/s&r-data to txt file or clipboard
-improved s&r loader
-new option in offset patch: skip original byte check
-"File not found" message will be skipped when filefilter is *.*
-improved path searching in Browse-For-File dialog in patcher
-updated ufmod player (XM music) to v1.19
-new option to optimze filesize of XM music files for ufmod
-dUP2 can read now old project files of dUP v1.xx
-minor bugfixes and changes

[2.13]
-fixed serious bug in search & replace loader
-fixed bug: dup2 did not saved window positions in dup2.ini
-fixed bug when building patcher/loader with skipped (empty) data
-add copy & paste functions
-add button for last used projects
-fileexport function can create missing folders now
-registry patch window is resizeable now
-fixed bug when pasting long binary data from ollydbg
-improved edit function for s&r and offset data
-add some keyboard shortcuts
-add unicode function in String2Hex Window
-fixed bug when saving projects
-improved loader timeout
-add new messagebox in patcher when file is in use
-updated ufmod player for the patcher
-minor code changes and bugfixes
-compiled with new masm version 9.0

[2.12]
-add "Registry Paths" module (usage of custom environment variables)
-now shows description of registry patchdata in main window
-add option to switch on XP styled dialogs
-add results box instead messagebox in check occurrence dialog

[2.11]
-support for custom window shape [RGN files]
-new "save on exit" dialog if something changed
-support for custom cursor
-fixed bug in loader installer
-minor bugfix s&r loader
-minor code changes in follow in ollydbg function

[2.10]
-add new feature: installer for loaders
-add about box dialog (can be modified now in resource)
-add option to follow addresses in ollydbg
-fixed stupid bug when ripping icons from *.exe/*.dll files
-dup2 remembers window positions now
-better drag&drop support (drag files into single dialog items)
-use ufmod player instead of mfmplayer for xm files
-add some usefull tooltips
-add warning message when quit s&r dialog with data in editboxes
-add file attribute option for attached files
-add some context menu
-improved save dialog (generates filename)
-add option to show/hide release info message in patcher dialog
-fixed bug in VirtualAddress calculation routine
-minor code changes and bug fixes

[2.09]
-add support for custom colored patchers
-add support for transparent patcher dialog
-commandline support for patcher (silent mode,set workdir...)
-coded new method to apply skin (*.res file) to patcher
-pattern check changed: separators "A-F" and "0-9" not allowed
-add option to hide dUP main window when edit Patchdata
-fixed bug in Offset Dialog
-minor bug fixes and code changes

[2.08]
-this version comes with a help file :)
-add: use of windows environment variables in pathnames
-now patching "readonly" files possible
-patcher asks to overwrite existing file attachments
-option to switch off warning when exit dUP with open project
-add: play/stop buttons for music in the settings dialog
-bug fixed: String2Hex Dialog doesnt crash now
-bug fixed: the patcher/loader can now contain any icon format
-bug fixed in inline patcher: problem with already patched targets
-loader improved: can transfer now commandline arguments
-changed date format to: "monthname day, year" by default
-add: function to select custom icon from exe/dll files
-add support for (Win)Upack packer (http://dwing.go.nease.net)
-minor fixes in patcher when searching target file manually...
-better backup system in patcher

[2.07]
-ugly bugs fixed in Search&Replace Engine core
-fixed another bug in s&r loader, when using "Patch All" option
-fixed bug: compare big files with different size
-new button in Patch Info Dialog to get today date
-add autocorrection for different patternlength

[2.06]
-add option to use smaller dll for xm music instead of bassmod.dll
-add check in S&R Dialog: Pattern must have same lenght
-add 'MemCheck' feature for search&replace loaders
-items can move up & down in the offset and s&r table
-load last file in "Check Occurrence" Dialog by default
-bug fixed in Offset Dialog

[2.05]
-add support for creating patcher/loader under win9x =)
-improved patcher with logbox instead of messageboxes
 note: old skins dont work with this version
-fixed bug: dont patch already inline patched targets
-fixed bug: dont add unused data to inline patched targets
-fixed bug for inline patcher (better entrypoint calculation)
-improved S&R loader: can detect changed exe now
-support for nspack packer (www.nsdsn.com) for packing patcher/loader

[2.04]
-add support for more trackerformats (it,xm,s3m,mtm,mod,umx)
-drag&drop support in all dialogs
-fixed bug with long releaseinfo & about message
-minor code change in patcher.exe

[2.03]
-patcher without xm music has smaller filesize (compressed)
-remember now last 'CheckOccurrence' filepath
-show warning when first byte is 0 in VirtualAddress Mode

[2.02]
-fixed bug: directorys are remembered now correctly
-add: comments for S&R projectdata

[2.01]
-serious (!) bug fixed in S&R procedures

[2.00]
-100% recoded
-multiple file patching
-compare files with different filesize
-unlimited patchdata
-Registry Patch
-File Attachment

[1.14]
-optimized search&replace routine (shorter & faster)
-fixed: Autoformat Bytes supports now also "??" string

[1.13]
-add: you also can use "??" instead of "**" in S&R Dialog
-add: move generated patch with mouse by clicking on any dialog place
-add: QuickString Function in S&R Dialog

[1.12]
-add: comments in S&R Projects
-add: "MemCheck" feature for loaders
-offset filecompare: file filter changed to "All Files *.*" as default
-ugly bug fixed when creating S&R Patcher...
-smaller patcher,loader code
-removed bug: inline patcher doesnt rename last section now

[1.11]
-selecting a packer is now easy.
 dUP detects packer and set optimal parameters
-fixed problem with upx: packing patcher for packed targets

[1.10]
-loader bug fixed when using xm files
-smaller patcher size when not using xm files
-Command line Packer bug fixed,when changing path
-about box msg fix,when changing text

[1.09]
-Removed "Options" Dialog,now easier to use
-add xm feature [playing Fast Tracker Modules]
-dUP remember now all important paths
-improved loader code
-fixed caption bug,when using custom *.res file

[1.08]
-fixed Bug under w2k when compare files
-add option to use custom "skins" (*.res files)

[1.07]
-add loader support for offset patching

[1.06]
-add Offset Patch Feature [also for packed exe's]
-Compare Function for Offset Patches
-Save/Open Offset Projects
-removed internel Packer;added option to choose your packer (upx,fsg,mew...)

[1.05]
-!!! Match Number will only patch the specified Number, and not the
 patterns before
-new "Check Occurence of Search Bytes" features; more info
-add Tab Control Navigation
-Hidden File Bug fixed

[1.00]
-first crappy release :D



Homepage
--------
http://navig8.to/diablo2oo2
http://diablo2oo2.cjb.net