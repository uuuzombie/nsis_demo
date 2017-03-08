;-------------------------------
;Start
 
!define MUI_PRODUCT "NSIS DEMO"
!define MUI_FILE "Demo"
!define MUI_VERSION ""
!define MUI_BRANDINGTEXT ""
CRCCheck On

;!include "${NSISDIR}\Contrib\Modern UI\System.nsh"
;!include "${NSISDIR}\Contrib\Modern UI 2\MUI2.nsh"
!include "MUI2.nsh"
  
;---------------------------------
;General

Name "${MUI_PRODUCT}"
Caption "${MUI_PRODUCT}"
Icon "Demo.ico"
OutFile "Installer_win32-x86_x64.exe"
;ShowInstDetails "nevershow"
;ShowUninstDetails "nevershow"
;SetCompressor "bzip2"
 
!define MUI_ICON "Demo.ico"
;!define MUI_UNICON "icon.ico"
;!define MUI_SPECIALBITMAP "Bitmap.bmp"

;--------------------------------
;Folder selection page
 
InstallDir "$PROGRAMFILES64\${MUI_PRODUCT}"
 
;--------------------------------
;Modern UI Configuration
 
!define MUI_WELCOMEPAGE  
!define MUI_LICENSEPAGE
!define MUI_DIRECTORYPAGE
!define MUI_ABORTWARNING
!define MUI_UNINSTALLER
!define MUI_UNCONFIRMPAGE
!define MUI_FINISHPAGE  
 
 
;-------------------------------- 
;Modern UI System
 
;!insertmacro MUI_SYSTEM 

;--------------------------------
;Data
 
LicenseData "license.txt"

;For removing Start Menu shortcut in Windows 7
;RequestExecutionLevel user

;SilentInstall silent
;AutoCloseWindow true

  
  
;--------------------------------
;Language
 
!insertmacro MUI_LANGUAGE "English"
  
;-------------------------------- 
;Installer Sections     
;Section "install" Installation info
Section "install"
 
	;Add files
	SetOutPath "$INSTDIR"
	File "${MUI_FILE}.exe"
	;File "${MUI_FILE}.ini"
	;File "license.txt"
	
	;File /r jre
	File /r bin
 
	;create desktop shortcut
	CreateShortCut "$DESKTOP\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" ""
 
	;create start-menu items
	CreateDirectory "$SMPROGRAMS\${MUI_PRODUCT}"
	CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
	CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" "" "$INSTDIR\${MUI_FILE}.exe" 0
 
	;write uninstall information to the registry
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\Uninstall.exe"
 
	WriteUninstaller "$INSTDIR\Uninstall.exe"
	
	;call some exe after install
	nsExec::ExecToStack '"$INSTDIR\bin\xxx.exe" "$EXEPATH" "$INSTDIR"'
 
SectionEnd


;--------------------------------    
;Uninstaller Section  
Section "Uninstall"

 	;Always delete uninstaller first
	Delete $INSTDIR\uninstaller.exe
	
	;Delete Files 
	RMDir /r "$INSTDIR\*.*"    
 
	;Remove the installation directory
	RMDir "$INSTDIR"
 
	;Delete Start Menu Shortcuts
	Delete "$DESKTOP\${MUI_PRODUCT}.lnk"
	Delete "$SMPROGRAMS\${MUI_PRODUCT}\*.*"
	RMDir  "$SMPROGRAMS\${MUI_PRODUCT}"
 
	;Delete Uninstaller And Unistall Registry Entries
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  
 
SectionEnd

;--------------------------------    
;MessageBox Section
 
;Function that calls a messagebox when installation finished correctly
;Function .onInstSuccess
;  MessageBox MB_OK "You have successfully installed ${MUI_PRODUCT}. "
;FunctionEnd
 
 
;Function un.onUninstSuccess
;  MessageBox MB_OK "You have successfully uninstalled ${MUI_PRODUCT}."
;FunctionEnd
