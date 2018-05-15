; Common NSIS macro for YAZ, Zebra, etc
; Copyright (C) Index Data
; See the file LICENSE for details.

!define VSVER "$%VisualStudioVersion%"

!define VS_REDIST_EXE "vc_redist.${VSARCH}.exe"

; VS 2017 defines VCToolsRedistDir env (and hopefully later versions too)
!if "${VSVER}" == "14.0"
!define VS_REDIST_FULL "$%VSINSTALLDIR%\VC\redist\1033\${VS_REDIST_EXE}"
!else
!define VS_REDIST_FULL "$%VCToolsRedistDir%${VS_REDIST_EXE}"
!endif

; For example can be found with regedit:
;  Microsoft Visual C++ 2013 x86 Minimum Runtime
!if "${VSARCH}" == "x64"
; 64-bit
!if "${VSVER}" == "14.0"
; Microsoft Visual C++ 2015 x64 Minimum Runtime - 14.0.23026
!define VS_REDIST_KEY "SOFTWARE\Classes\Installer\Products\51E9E3D0A7EDB003691F4BFA219B4688"
!endif
!if "${VSVER}" == "15.0"
; Microsoft Visual C++ 2017 x64 Minimum Runtime - 14.13.26020
!define VS_REDIST_KEY "SOFTWARE\Classes\Installer\Products\4BD6D1222E64C3330BB9F59453D19008"
!endif

InstallDir "$PROGRAMFILES64\$(^Name)"
!else
; 32-bit
!if "${VSVER}" == "14.0"
; Microsoft Visual C++ 2015 x86 Minimum Runtime - 14.0.23026
!define VS_REDIST_KEY "SOFTWARE\Classes\Installer\Products\55E3652ACEB38283D8765E8E9B8E6B57"
!endif
!if "${VSVER}" == "15.0"
; Microsoft Visual C++ 2017 x86 Minimum Runtime - 14.13.26020
!define VS_REDIST_KEY "SOFTWARE\Classes\Installer\Products\C6F172F8B7E6A0D359B1E6B796D487DB"
!endif

InstallDir "$PROGRAMFILES\$(^Name)"
!endif

