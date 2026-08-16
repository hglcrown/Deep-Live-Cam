!include "MUI2.nsh"
!include "FileFunc.nsh"

Name "Deep-Live-Cam"
OutFile "Deep-Live-Cam_installer.exe"
; 装入 LocalAppData：软件首次运行会从 HuggingFace 下载 AI 模型到安装目录下的 models/，
; 放到用户可写目录可避免 UAC 与写权限问题。
InstallDir "$LOCALAPPDATA\Deep-Live-Cam"
RequestExecutionLevel user

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "SimpChinese"

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  ; 打包 PyInstaller --onedir 产物
  File /r "dist\DeepLiveCam\*"

  ; 开始菜单快捷方式
  CreateDirectory "$SMPROGRAMS\Deep-Live-Cam"
  CreateShortCut "$SMPROGRAMS\Deep-Live-Cam\Deep-Live-Cam.lnk" "$INSTDIR\DeepLiveCam.exe"

  ; 桌面快捷方式
  CreateShortCut "$DESKTOP\Deep-Live-Cam.lnk" "$INSTDIR\DeepLiveCam.exe"

  ; 卸载信息（AGPL-3.0：源码随公开 fork 提供，满足开源义务）
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Deep-Live-Cam" "DisplayName" "Deep-Live-Cam"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Deep-Live-Cam" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Deep-Live-Cam" "DisplayIcon" "$INSTDIR\DeepLiveCam.exe"
SectionEnd

Section "Uninstall"
  RMDir /r "$INSTDIR"
  Delete "$DESKTOP\Deep-Live-Cam.lnk"
  Delete "$SMPROGRAMS\Deep-Live-Cam\Deep-Live-Cam.lnk"
  RMDir "$SMPROGRAMS\Deep-Live-Cam"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Deep-Live-Cam"
SectionEnd
