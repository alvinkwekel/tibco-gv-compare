@echo OFF
REM Handle input arguments as file names
SET baseFilePath=%1
SET compareFilePath=%2
SET tempDirPrefix=appmanange-compare

REM Remove old temp files
for /d %%x in (%TEMP%\%tempDirPrefix%*) do rd /s /q "%%x"

REM Get file name from input argument path (these vars are not used at the moment)
FOR %%b IN ("%baseFilePath%") DO (
    SET baseFileName=%%~nxb
)

FOR %%c IN ("%compareFilePath%") DO (
    SET compareFileName=%%~nxc
)

REM Unique file temp working dir
FOR /F "delims=/ tokens=1-3" %%a IN ("%DATE:~4%") DO (
	FOR /f "delims=:. tokens=1-4" %%m IN ("%TIME: =0%") DO (
		SET dirName=%tempDirPrefix%-%%c%%b%%a-%%m%%n%%o%%p
	)
)
SET tempDirPath=%TEMP%\%dirName%

REM Compare output file name
SET compareOutXmlName=out.xml
SET compareOutHtmlName=out.html

REM Compare output file path
SET compareOutXmlPath=%tempDirPath%\%compareOutXmlName%
SET compareOutHtmlPath=%tempDirPath%\%compareOutHtmlName%

MKDIR %tempDirPath%
call compare.bat %baseFilePath% %compareFilePath% %compareOutXmlPath%
call table.bat %compareOutXmlPath% %compareOutHtmlPath%
explorer %compareOutHtmlPath%
REM RMDIR /S /Q %tempDirPath%