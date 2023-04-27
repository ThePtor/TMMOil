@echo off
set /p input="Zadej cestu do složky data (lomeno na konci): "
echo %input%
echo %input% > Processing/Auction/windows-amd64/dataPath.txt
echo %input% > Processing/Auction/dataPath.txt
echo %input% > Processing/Mining/windows-amd64/dataPath.txt
echo %input% > Processing/Mining/dataPath.txt
echo %input% > Processing/Test/windows-amd64/dataPath.txt
echo %input% > Processing/Test/dataPath.txt
echo %input% > Processing/Upgrade/windows-amd64/dataPath.txt
echo %input% > Processing/Upgrade/dataPath.txt
pause