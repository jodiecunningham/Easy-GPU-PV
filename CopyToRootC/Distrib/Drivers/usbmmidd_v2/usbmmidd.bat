@cd /d "%~dp0"

@goto %PROCESSOR_ARCHITECTURE%
@exit

:AMD64
@cmd /c deviceinstaller64.exe install usbmmidd.inf usbmmidd
@cmd /c deviceinstaller64.exe enableidd 1
@cmd /c c:\Distrib\Utils\MultiMonitorTool.exe /disable 1
@cmd /c c:\Distrib\Utils\Qres.exe /x:1920 /y:1080
@goto end

:x86
@cmd /c deviceinstaller.exe install usbmmidd.inf usbmmidd
@cmd /c deviceinstaller.exe enableidd 1
@cmd /c c:\Distrib\Utils\MultiMonitorTool.exe /disable 1
@cmd /c c:\Distrib\Utils\Qres.exe /x:1920 /y:1080

:end
@pause
