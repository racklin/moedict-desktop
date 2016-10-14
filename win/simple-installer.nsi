; simple-installer.nsi for moedict-desktop
;

;--------------------------------

; load lang to zhTW
LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

; Define Application-Name
LangString AppName ${LANG_ENGLISH} "MoeDictDesktop"
LangString AppName ${LANG_TRADCHINESE} "萌典-桌面離線版"

; The name of the installer
Name "$(AppName)"

; NSIS 3.0 
!define DisplayName "$(AppName)"
!define InstName "MoedictDesktop"

; The file to write
OutFile "moedict-desktop-setup.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\${InstName}"

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NSIS_${InstName}" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin


;--------------------------------

; Pages
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "MoedictDesktop Install"

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File /r "staging\*.*"

  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\NSIS_${InstName}" "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${InstName}" "DisplayName" "${DisplayName}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${InstName}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${InstName}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${InstName}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Optional section (can be disabled by the user)
Section "Shortcuts"

  CreateDirectory "$SMPROGRAMS\${DisplayName}"
  CreateShortCut "$SMPROGRAMS\${DisplayName}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${DisplayName}\${DisplayName}.lnk" "$INSTDIR\MoeDict-Desktop.exe" "" "$INSTDIR\MoeDict-Desktop.exe" 0
  CreateShortCut "$Desktop\${DisplayName}.lnk" "$INSTDIR\MoeDict-Desktop.exe" "" "$INSTDIR\MoeDict-Desktop.exe" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${InstName}"
  DeleteRegKey HKLM "SOFTWARE\NSIS_${InstName}"

  ; Remove files and uninstaller
  Delete $INSTDIR\*.*
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\${DisplayName}\*.*"
  Delete "$Desktop\${DisplayName}.lnk"

  ; Remove directories used
  RMDir /r "$SMPROGRAMS\${DisplayName}"
  RMDir /r "$INSTDIR"
  
  ; Remote XULRunner Profile
  RMDir /r "$PROFILE\Application Data\moedict-desktop"
  ; Windows2000 or above
  RMDir /r "$LOCALAPPDATA\moedict-desktop"

SectionEnd
