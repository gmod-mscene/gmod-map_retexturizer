@echo off

echo I'm going to create 1512 vmt files for Map Retexturizer.
echo Close me if you want to cancel.
echo.

pause

for /l %%x in (1, 1, 1512) do (
	echo "VertexlitGeneric" > file%%x.vmt
	echo { >> file%%x.vmt
	echo 	"$basetexture" "mapretexturizer/file%%x" >> file%%x.vmt
	echo 	"$basetexture2" "mapretexturizer/file%%x" >> file%%x.vmt
	echo } >> file%%x.vmt
)
