# ***** BEGIN LICENSE BLOCK *****
# Version: MPL 1.1/GPL 2.0/LGPL 2.1
#
# The contents of this file are subject to the Mozilla Public License Version
# 1.1 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
# http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
# for the specific language governing rights and limitations under the
# License.
#
# The Original Code is the Mozilla Installer code.
#
# The Initial Developer of the Original Code is Mozilla Foundation
# Portions created by the Initial Developer are Copyright (C) 2006
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#  Robert Strong <robert.bugzilla@gmail.com>
#
# Alternatively, the contents of this file may be used under the terms of
# either the GNU General Public License Version 2 or later (the "GPL"), or
# the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
# in which case the provisions of the GPL or the LGPL are applicable instead
# of those above. If you wish to allow use of your version of this file only
# under the terms of either the GPL or the LGPL, and not to allow others to
# use your version of this file under the terms of the MPL, indicate your
# decision by deleting the provisions above and replace them with the notice
# and other provisions required by the GPL or the LGPL. If you do not delete
# the provisions above, a recipient may use your version of this file under
# the terms of any one of the MPL, the GPL or the LGPL.
#
# ***** END LICENSE BLOCK *****

!macro PostUpdate
  ${CreateShortcutsLog}

  ; Remove registry entries for non-existent apps and for apps that point to our
  ; install location in the Software\${AppRegName} key and uninstall registry entries
  ; that point to our install location for both HKCU and HKLM.
  SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)
  ${RegCleanMain} "Software\${AppRegName}"
  ${RegCleanUninstall}
  ; Win7 taskbar and start menu link maintenance
  Call FixShortcutAppModelIDs

  ClearErrors
  WriteRegStr HKLM "Software\${AppRegName}" "${BrandShortName}InstallerTest" "Write Test"
  ${If} ${Errors}
    StrCpy $TmpVal "HKCU" ; used primarily for logging
  ${Else}
    SetShellVarContext all    ; Set SHCTX to all users (e.g. HKLM)
    DeleteRegValue HKLM "Software\${AppRegName}" "${BrandShortName}InstallerTest"
    StrCpy $TmpVal "HKLM" ; used primarily for logging
    ${RegCleanMain} "Software\${AppRegName}"
    ${RegCleanUninstall}
    ${SetAppLSPCategories} ${LSP_CATEGORIES}

    ; Win7 taskbar and start menu link maintenance
    Call FixShortcutAppModelIDs

    ReadRegStr $0 HKLM "Software\${AppVendor}\${AppRegName}" "CurrentVersion"
    ${If} "$0" != "${GREVersion}"
      WriteRegStr HKLM "Software\${AppVendor}\${AppRegName}" "CurrentVersion" "${GREVersion}"
    ${EndIf}
  ${EndIf}

  ; Migrate the application's Start Menu directory to a single shortcut in the
  ; root of the Start Menu Programs directory.
  ${MigrateStartMenuShortcut}

  ; Adds a pinned Task Bar shortcut (see MigrateTaskBarShortcut for details).
  ${MigrateTaskBarShortcut}

  ${SetAppKeys}
  ${FixClassKeys}
  ${SetUninstallKeys}

  ; Remove files that may be left behind by the application in the
  ; VirtualStore directory.
  ${CleanVirtualStore}
!macroend
!define PostUpdate "!insertmacro PostUpdate"

!macro SetAsDefaultAppGlobal
!macroend
!define SetAsDefaultAppGlobal "!insertmacro SetAsDefaultAppGlobal"

; Removes shortcuts for this installation. This should also remove the
; application from Open With for the file types the application handles
; (bug 370480).
!macro HideShortcuts
  ${StrFilter} "${FileMainEXE}" "+" "" "" $0
  StrCpy $R1 "Software\Clients\StartMenuInternet\$0\InstallInfo"
  WriteRegDWORD HKLM "$R1" "IconsVisible" 0

  SetShellVarContext all  ; Set $DESKTOP to All Users
  ${Unless} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
    SetShellVarContext current  ; Set $DESKTOP to the current user's desktop
  ${EndUnless}

  ${If} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
    ShellLink::GetShortCutArgs "$DESKTOP\${BrandFullName}.lnk"
    Pop $0
    ${If} "$0" == ""
      ShellLink::GetShortCutTarget "$DESKTOP\${BrandFullName}.lnk"
      Pop $0
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR\${FileMainEXE}"
        Delete "$DESKTOP\${BrandFullName}.lnk"
      ${EndIf}
    ${EndIf}
  ${EndIf}

  SetShellVarContext all  ; Set $SMPROGRAMS to All Users
  ${Unless} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    SetShellVarContext current  ; Set $SMPROGRAMS to the current user's Start
                                ; Menu Programs directory
  ${EndUnless}

  ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    ShellLink::GetShortCutArgs "$SMPROGRAMS\${BrandFullName}.lnk"
    Pop $0
    ${If} "$0" == ""
      ShellLink::GetShortCutTarget "$SMPROGRAMS\${BrandFullName}.lnk"
      Pop $0
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR\${FileMainEXE}"
        Delete "$SMPROGRAMS\${BrandFullName}.lnk"
      ${EndIf}
    ${EndIf}
  ${EndIf}

  ${If} ${FileExists} "$QUICKLAUNCH\${BrandFullName}.lnk"
    ShellLink::GetShortCutArgs "$QUICKLAUNCH\${BrandFullName}.lnk"
    Pop $0
    ${If} "$0" == ""
      ShellLink::GetShortCutTarget "$QUICKLAUNCH\${BrandFullName}.lnk"
      Pop $0
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR\${FileMainEXE}"
        Delete "$QUICKLAUNCH\${BrandFullName}.lnk"
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define HideShortcuts "!insertmacro HideShortcuts"

; Adds shortcuts for this installation. This should also add the application
; to Open With for the file types the application handles (bug 370480).
!macro ShowShortcuts
  ${StrFilter} "${FileMainEXE}" "+" "" "" $0
  StrCpy $R1 "Software\Clients\StartMenuInternet\$0\InstallInfo"
  WriteRegDWORD HKLM "$R1" "IconsVisible" 1

  SetShellVarContext all  ; Set $DESKTOP to All Users
  ${Unless} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
    CreateShortCut "$DESKTOP\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
    ${If} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
      ShellLink::SetShortCutWorkingDirectory "$DESKTOP\${BrandFullName}.lnk" "$INSTDIR"
      ${If} ${AtLeastWin7}
        ApplicationID::Set "$DESKTOP\${BrandFullName}.lnk" "${AppUserModelID}"
      ${EndIf}
    ${Else}
      SetShellVarContext current  ; Set $DESKTOP to the current user's desktop
      ${Unless} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
        CreateShortCut "$DESKTOP\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
        ${If} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
          ShellLink::SetShortCutWorkingDirectory "$DESKTOP\${BrandFullName}.lnk" \
                                                 "$INSTDIR"
          ${If} ${AtLeastWin7}
            ApplicationID::Set "$DESKTOP\${BrandFullName}.lnk" "${AppUserModelID}"
          ${EndIf}
        ${EndIf}
      ${EndUnless}
    ${EndIf}
  ${EndUnless}

  SetShellVarContext all  ; Set $SMPROGRAMS to All Users
  ${Unless} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    CreateShortCut "$SMPROGRAMS\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
    ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
      ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\${BrandFullName}.lnk" \
                                             "$INSTDIR"
      ${If} ${AtLeastWin7}
        ApplicationID::Set "$SMPROGRAMS\${BrandFullName}.lnk" "${AppUserModelID}"
      ${EndIf}
    ${Else}
      SetShellVarContext current  ; Set $SMPROGRAMS to the current user's Start
                                  ; Menu Programs directory
      ${Unless} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
        CreateShortCut "$SMPROGRAMS\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
        ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
          ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\${BrandFullName}.lnk" \
                                                 "$INSTDIR"
          ${If} ${AtLeastWin7}
            ApplicationID::Set "$SMPROGRAMS\${BrandFullName}.lnk" "${AppUserModelID}"
          ${EndIf}
        ${EndIf}
      ${EndUnless}
    ${EndIf}
  ${EndUnless}

  ; Windows 7 doesn't use the QuickLaunch directory
  ${Unless} ${AtLeastWin7}
  ${AndUnless} ${FileExists} "$QUICKLAUNCH\${BrandFullName}.lnk"
    CreateShortCut "$QUICKLAUNCH\${BrandFullName}.lnk" \
                   "$INSTDIR\${FileMainEXE}"
    ${If} ${FileExists} "$QUICKLAUNCH\${BrandFullName}.lnk"
      ShellLink::SetShortCutWorkingDirectory "$QUICKLAUNCH\${BrandFullName}.lnk" \
                                             "$INSTDIR"
    ${EndIf}
  ${EndUnless}
!macroend
!define ShowShortcuts "!insertmacro ShowShortcuts"

; Add Software\${AppRegName}\ registry entries (uses SHCTX).
!macro SetAppKeys
  ${GetLongPath} "$INSTDIR" $8
  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal}\${AppVersion} (${AB_CD})\Main"
  ${WriteRegStr2} $TmpVal "$0" "Install Directory" "$8" 0
  ${WriteRegStr2} $TmpVal "$0" "PathToExe" "$8\${FileMainEXE}" 0

  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal}\${AppVersion} (${AB_CD})\Uninstall"
  ${WriteRegStr2} $TmpVal "$0" "Description" "${BrandFullNameInternal} ${AppVersion} (${ARCH} ${AB_CD})" 0

  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal}\${AppVersion} (${AB_CD})"
  ${WriteRegStr2} $TmpVal  "$0" "" "${AppVersion} (${AB_CD})" 0

  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal} ${AppVersion}\bin"
  ${WriteRegStr2} $TmpVal "$0" "PathToExe" "$8\${FileMainEXE}" 0

  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal} ${AppVersion}\extensions"
  ${WriteRegStr2} $TmpVal "$0" "Components" "$8\components" 0
  ${WriteRegStr2} $TmpVal "$0" "Plugins" "$8\plugins" 0

  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal} ${AppVersion}"
  ${WriteRegStr2} $TmpVal "$0" "GeckoVer" "${GREVersion}" 0

  StrCpy $0 "Software\${AppRegName}\${BrandFullNameInternal}"
  ${WriteRegStr2} $TmpVal "$0" "" "${GREVersion}" 0
  ${WriteRegStr2} $TmpVal "$0" "CurrentVersion" "${AppVersion} (${AB_CD})" 0
!macroend
!define SetAppKeys "!insertmacro SetAppKeys"

; Add uninstall registry entries. This macro tests for write access to determine
; if the uninstall keys should be added to HKLM or HKCU.
!macro SetUninstallKeys
  StrCpy $0 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${BrandFullNameInternal} ${AppVersion} (${ARCH} ${AB_CD})"

  WriteRegStr HKLM "$0" "${BrandShortName}InstallerTest" "Write Test"
  ${If} ${Errors}
    StrCpy $1 "HKCU"
    SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)
  ${Else}
    StrCpy $1 "HKLM"
    SetShellVarContext all     ; Set SHCTX to all users (e.g. HKLM)
    DeleteRegValue HKLM "$0" "${BrandShortName}InstallerTest"
  ${EndIf}

  ${GetLongPath} "$INSTDIR" $8

  ; Write the uninstall registry keys
  ${WriteRegStr2} $1 "$0" "Comments" "${BrandFullNameInternal} ${AppVersion} (${ARCH} ${AB_CD})" 0
  ${WriteRegStr2} $1 "$0" "DisplayIcon" "$8\${FileMainEXE},0" 0
  ${WriteRegStr2} $1 "$0" "DisplayName" "${BrandFullNameInternal} ${AppVersion} (${ARCH} ${AB_CD})" 0
  ${WriteRegStr2} $1 "$0" "DisplayVersion" "${AppVersion}" 0
  ${WriteRegStr2} $1 "$0" "InstallLocation" "$8" 0
  ${WriteRegStr2} $1 "$0" "Publisher" "${AppVendor}" 0
  ${WriteRegStr2} $1 "$0" "UninstallString" "$8\uninstall\helper.exe" 0
  ${WriteRegStr2} $1 "$0" "URLInfoAbout" "${URLInfoAbout}" 0
  ${WriteRegStr2} $1 "$0" "URLUpdateInfo" "${URLUpdateInfo}" 0
  ${WriteRegDWORD2} $1 "$0" "NoModify" 1 0
  ${WriteRegDWORD2} $1 "$0" "NoRepair" 1 0

  ${GetSize} "$8" "/S=0K" $R2 $R3 $R4
  ${WriteRegDWORD2} $1 "$0" "EstimatedSize" $R2 0

  ${If} "$TmpVal" == "HKLM"
    SetShellVarContext all     ; Set SHCTX to all users (e.g. HKLM)
  ${Else}
    SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)
  ${EndIf}
!macroend
!define SetUninstallKeys "!insertmacro SetUninstallKeys"

; Add app specific handler registry entries under Software\Classes if they
; don't exist (does not use SHCTX).
!macro FixClassKeys
  StrCpy $1 "SOFTWARE\Classes"

  ; File handler keys and name value pairs that may need to be created during
  ; install or upgrade.
  ReadRegStr $0 HKCR ".shtml" "Content Type"
  ${If} "$0" == ""
    StrCpy $0 "$1\.shtml"
    ${WriteRegStr2} $TmpVal "$1\.shtml" "" "shtmlfile" 0
    ${WriteRegStr2} $TmpVal "$1\.shtml" "Content Type" "text/html" 0
    ${WriteRegStr2} $TmpVal "$1\.shtml" "PerceivedType" "text" 0
  ${EndIf}

  ReadRegStr $0 HKCR ".xht" "Content Type"
  ${If} "$0" == ""
    ${WriteRegStr2} $TmpVal "$1\.xht" "" "xhtfile" 0
    ${WriteRegStr2} $TmpVal "$1\.xht" "Content Type" "application/xhtml+xml" 0
  ${EndIf}

  ReadRegStr $0 HKCR ".xhtml" "Content Type"
  ${If} "$0" == ""
    ${WriteRegStr2} $TmpVal "$1\.xhtml" "" "xhtmlfile" 0
    ${WriteRegStr2} $TmpVal "$1\.xhtml" "Content Type" "application/xhtml+xml" 0
  ${EndIf}
!macroend
!define FixClassKeys "!insertmacro FixClassKeys"

; Adds a pinned shortcut to Task Bar on update for Windows 7 and above if this
; macro has never been called before and the application is default (see
; PinToTaskBar for more details).
!macro MigrateTaskBarShortcut
  ${GetShortcutsLogPath} $0
  ${If} ${FileExists} "$0"
    ClearErrors
    ReadINIStr $1 "$0" "TASKBAR" "Migrated"
    ${If} ${Errors}
      ClearErrors
      WriteIniStr "$0" "TASKBAR" "Migrated" "true"
      ${If} ${AtLeastWin7}
        ; Check if the Firefox is the http handler for this user
        SetShellVarContext current ; Set SHCTX to the current user
        ${IsHandlerForInstallDir} "http" $R9
        ${If} $TmpVal == "HKLM"
          SetShellVarContext all ; Set SHCTX to all users
        ${EndIf}
        ${If} "$R9" == "true"
          ${PinToTaskBar}
        ${EndIf}
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define MigrateTaskBarShortcut "!insertmacro MigrateTaskBarShortcut"

; Adds a pinned Task Bar shortcut on Windows 7 if there isn't one for the main
; application executable already. Existing pinned shortcuts for the same
; application model ID must be removed first to prevent breaking the pinned
; item's lists but multiple installations with the same application model ID is
; an edgecase. If removing existing pinned shortcuts with the same application
; model ID removes a pinned pinned Start Menu shortcut this will also add a
; pinned Start Menu shortcut.
!macro PinToTaskBar
  ${If} ${AtLeastWin7}
    StrCpy $8 "false" ; Whether a shortcut had to be created
    ${IsPinnedToTaskBar} "$INSTDIR\${FileMainEXE}" $R9
    ${If} "$R9" == "false"
      ; Find an existing Start Menu shortcut or create one to use for pinning
      ${GetShortcutsLogPath} $0
      ${If} ${FileExists} "$0"
        ClearErrors
        ReadINIStr $1 "$0" "STARTMENU" "Shortcut0"
        ${Unless} ${Errors}
          SetShellVarContext all ; Set SHCTX to all users
          ${Unless} ${FileExists} "$SMPROGRAMS\$1"
            SetShellVarContext current ; Set SHCTX to the current user
            ${Unless} ${FileExists} "$SMPROGRAMS\$1"
              StrCpy $8 "true"
              CreateShortCut "$SMPROGRAMS\$1" "$INSTDIR\${FileMainEXE}"
              ${If} ${FileExists} "$SMPROGRAMS\$1"
                ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\$1" \
                                                       "$INSTDIR"
                ApplicationID::Set "$SMPROGRAMS\$1" "${AppUserModelID}"
              ${EndIf}
            ${EndUnless}
          ${EndUnless}

          ${If} ${FileExists} "$SMPROGRAMS\$1"
            ; Count of Start Menu pinned shortcuts before unpinning.
            ${PinnedToStartMenuLnkCount} $R9

            ; Having multiple shortcuts pointing to different installations with
            ; the same AppUserModelID (e.g. side by side installations of the
            ; same version) will make the TaskBar shortcut's lists into an bad
            ; state where the lists are not shown. To prevent this first
            ; uninstall the pinned item.
            ApplicationID::UninstallPinnedItem "$SMPROGRAMS\$1"

            ; Count of Start Menu pinned shortcuts after unpinning.
            ${PinnedToStartMenuLnkCount} $R8

            ; If there is a change in the number of Start Menu pinned shortcuts
            ; assume that unpinning unpinned a side by side installation from
            ; the Start Menu and pin this installation to the Start Menu.
            ${Unless} $R8 == $R9
              ; Pin the shortcut to the Start Menu. 5381 is the shell32.dll
              ; resource id for the "Pin to Start Menu" string.
              InvokeShellVerb::DoIt "$SMPROGRAMS" "$1" "5381"
            ${EndUnless}

            ; Pin the shortcut to the TaskBar. 5386 is the shell32.dll resource
            ; id for the "Pin to Taskbar" string.
            InvokeShellVerb::DoIt "$SMPROGRAMS" "$1" "5386"

            ; Delete the shortcut if it was created
            ${If} "$8" == "true"
              Delete "$SMPROGRAMS\$1"
            ${EndIf}
          ${EndIf}

          ${If} $TmpVal == "HKCU"
            SetShellVarContext current ; Set SHCTX to the current user
          ${Else}
            SetShellVarContext all ; Set SHCTX to all users
          ${EndIf}
        ${EndUnless}
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define PinToTaskBar "!insertmacro PinToTaskBar"

; Adds a shortcut to the root of the Start Menu Programs directory if the
; application's Start Menu Programs directory exists with a shortcut pointing to
; this installation directory. This will also remove the old shortcuts and the
; application's Start Menu Programs directory by calling the RemoveStartMenuDir
; macro.
!macro MigrateStartMenuShortcut
  ${GetShortcutsLogPath} $0
  ${If} ${FileExists} "$0"
    ClearErrors
    ReadINIStr $5 "$0" "SMPROGRAMS" "RelativePathToDir"
    ${Unless} ${Errors}
      ClearErrors
      ReadINIStr $1 "$0" "STARTMENU" "Shortcut0"
      ${If} ${Errors}
        ; The STARTMENU ini section doesn't exist.
        ${LogStartMenuShortcut} "${BrandFullName}.lnk"
        ${GetLongPath} "$SMPROGRAMS" $2
        ${GetLongPath} "$2\$5" $1
        ${If} "$1" != ""
          ClearErrors
          ReadINIStr $3 "$0" "SMPROGRAMS" "Shortcut0"
          ${Unless} ${Errors}
            ${If} ${FileExists} "$1\$3"
              ShellLink::GetShortCutTarget "$1\$3"
              Pop $4
              ${If} "$INSTDIR\${FileMainEXE}" == "$4"
                CreateShortCut "$SMPROGRAMS\${BrandFullName}.lnk" \
                               "$INSTDIR\${FileMainEXE}"
                ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
                  ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\${BrandFullName}.lnk" \
                                                         "$INSTDIR"
                  ${If} ${AtLeastWin7}
                    ApplicationID::Set "$SMPROGRAMS\${BrandFullName}.lnk" \
                                       "${AppUserModelID}"
                  ${EndIf}
                ${EndIf}
              ${EndIf}
            ${EndIf}
          ${EndUnless}
        ${EndIf}
      ${EndIf}
      ; Remove the application's Start Menu Programs directory, shortcuts, and
      ; ini section.
      ${RemoveStartMenuDir}
    ${EndUnless}
  ${EndIf}
!macroend
!define MigrateStartMenuShortcut "!insertmacro MigrateStartMenuShortcut"

; Removes the application's start menu directory along with its shortcuts if
; they exist and if they exist creates a start menu shortcut in the root of the
; start menu directory (bug 598779). If the application's start menu directory
; is not empty after removing the shortucts the directory will not be removed
; since these additional items were not created by the installer (uses SHCTX).
!macro RemoveStartMenuDir
  ${GetShortcutsLogPath} $0
  ${If} ${FileExists} "$0"
    ; Delete Start Menu Programs shortcuts, directory if it is empty, and
    ; parent directories if they are empty up to but not including the start
    ; menu directory.
    ${GetLongPath} "$SMPROGRAMS" $1
    ClearErrors
    ReadINIStr $2 "$0" "SMPROGRAMS" "RelativePathToDir"
    ${Unless} ${Errors}
      ${GetLongPath} "$1\$2" $2
      ${If} "$2" != ""
        ; Delete shortucts in the Start Menu Programs directory.
        StrCpy $3 0
        ${Do}
          ClearErrors
          ReadINIStr $4 "$0" "SMPROGRAMS" "Shortcut$3"
          ; Stop if there are no more entries
          ${If} ${Errors}
            ${ExitDo}
          ${EndIf}
          ${If} ${FileExists} "$2\$4"
            ShellLink::GetShortCutTarget "$2\$4"
            Pop $5
            ${If} "$INSTDIR\${FileMainEXE}" == "$5"
              Delete "$2\$4"
            ${EndIf}
          ${EndIf}
          IntOp $3 $3 + 1 ; Increment the counter
        ${Loop}
        ; Delete Start Menu Programs directory and parent directories
        ${Do}
          ; Stop if the current directory is the start menu directory
          ${If} "$1" == "$2"
            ${ExitDo}
          ${EndIf}
          ClearErrors
          RmDir "$2"
          ; Stop if removing the directory failed
          ${If} ${Errors}
            ${ExitDo}
          ${EndIf}
          ${GetParent} "$2" $2
        ${Loop}
      ${EndIf}
      DeleteINISec "$0" "SMPROGRAMS"
    ${EndUnless}
  ${EndIf}
!macroend
!define RemoveStartMenuDir "!insertmacro RemoveStartMenuDir"

; Creates the shortcuts log ini file with the appropriate entries if it doesn't
; already exist.
!macro CreateShortcutsLog
  ${GetShortcutsLogPath} $0
  ${Unless} ${FileExists} "$0"
    ${LogStartMenuShortcut} "${BrandFullName}.lnk"
    ${LogQuickLaunchShortcut} "${BrandFullName}.lnk"
    ${LogDesktopShortcut} "${BrandFullName}.lnk"
  ${EndUnless}
!macroend
!define CreateShortcutsLog "!insertmacro CreateShortcutsLog"

; The files to check if they are in use during (un)install so the restart is
; required message is displayed. All files must be located in the $INSTDIR
; directory.
!macro PushFilesToCheck
  ; The first string to be pushed onto the stack MUST be "end" to indicate
  ; that there are no more files to check in $INSTDIR and the last string
  ; should be ${FileMainEXE} so if it is in use the CheckForFilesInUse macro
  ; returns after the first check.
  Push "end"
  Push "AccessibleMarshal.dll"
  Push "freebl3.dll"
  Push "nssckbi.dll"
  Push "nspr4.dll"
  Push "nssdbm3.dll"
  Push "mozsqlite3.dll"
  Push "xpcom.dll"
  Push "crashreporter.exe"
  Push "updater.exe"
  Push "${FileMainEXE}"
!macroend
!define PushFilesToCheck "!insertmacro PushFilesToCheck"

; Helper for updating the shortcut application model IDs.
Function FixShortcutAppModelIDs
  ${UpdateShortcutAppModelIDs} "$INSTDIR\${FileMainEXE}" "${AppUserModelID}" $0
FunctionEnd

; The !ifdef NO_LOG prevents warnings when compiling the installer.nsi due to
; this function only being used by the uninstaller.nsi.
!ifdef NO_LOG

Function SetAsDefaultAppUser
FunctionEnd
!define SetAsDefaultAppUser "Call SetAsDefaultAppUser"

!endif
