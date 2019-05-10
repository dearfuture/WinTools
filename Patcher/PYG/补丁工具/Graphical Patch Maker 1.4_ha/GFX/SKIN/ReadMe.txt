Graphical Patch-Generator


Place In this Folder 'SKIN' all the resources Files necessary to build correctly the Patch.
Names of this files must be Absolutly respected :

- patch.rc 	> the resource script
- resource.h	> Header resources Infos 


Bitmaps

- 4 Bitmaps	> The skin, and the 3 buttons (PATCH, ABOUT, EXIT)

FileNames of the bitmaps are free, cause they are loaded by Patch.rc, But inside Patch.rc names
of resources need to be respected. 


Inside patch.rc
---------------

- patch.rc
 -Bitmap
  -IDB_ABOUT 	(ABOUT Bitmap button )
  -IDB_BITMAP1 	(Skin)
  -IDB_EXIT	(EXIT Bitmap button)
  -IDB_PATCH	(PATCH Bitmap button)
 -Cursor
  -IDC_CURSOR1	(mouse pointer)
 -Dialog
  -IDD_DIALOG	(Interface Window)
 -"MUSIC"
  -ID_MUSIC	(The xm music File)


DO NOT CHANGE ANY RESOURCE NAMES ELSE THE COMPILATION WILL BE IMPOSSIBLE.
