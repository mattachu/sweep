#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Comment=Created by M J Easton
#AutoIt3Wrapper_Res_Description=Create a batch of input files from a batch definition file and a template
#AutoIt3Wrapper_Res_Fileversion=0.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=Creative Commons Attribution ShareAlike
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 Script:         sweep
 AutoIt Version: 3.3.14.2
 Author:         Matt Easton
 Created:        2018.01.15
 Modified:       2018.01.15
 Version:        0.0.1.0

 Script Function:
    Create a batch of input files from a batch definition file and a template
	Based on sweepLORASR v0.4.4.0

#ce ----------------------------------------------------------------------------

; Load libraries
#include "sweep.common.au3"
#include "sweep.progress.au3"
#include "sweep.functions.au3"

; Program version
Global CONST $g_sProgramName = "sweep"
Global CONST $g_sProgramVersion = "0.0.1.0"

; Declarations
Local $iResult = 0
Local $sFolder = ""

; Create log file
$g_sLogFile = DateTimeFileName($g_sProgramName, ".log.md")
CreateLogFile($g_sLogFile, @WorkingDir)
LogVersions($g_sProgramName, $g_sProgramVersion)

; Get global settings
LogMessage("Loading global settings...", 2, "sweep")
Local $sProgramPath, $sSimulationProgram, $sSweepFile, $sTemplateFile, $sResultsFile, $sPlotFile, $sInputFolder, $sOutputFolder, $sRunFolder, $sIncompleteFolder
Local $bCleanup
$iResult = GetSettings(@WorkingDir, $sProgramPath, $sSimulationProgram, $sSweepFile, $sTemplateFile, $sResultsFile, $sPlotFile, $sInputFolder, $sOutputFolder, $sRunFolder, $sIncompleteFolder, $bCleanup)
If (Not $iResult) Or @error Then
    ThrowError("Error loading global settings", 1, "sweep", @error)
    Exit 1
EndIf

; Check command line parameters
LogMessage("Checking command line parameters...", 2, "sweep")
If $CmdLine[0] > 0 Then
	$sTemplateFile = $CmdLine[1]
Else
	$sTemplateFile = InputBox("sweep", "Enter the filename of the input file to modify:")
EndIf
LogMessage("Using input template filename: `" & $sTemplateFile & "`", 3, "sweep")
If @error Then
    ThrowError("Error checking command line parameters", 1, "sweep", @error)
    Exit 3
EndIf

; Get working directory if run from program directory
LogMessage("Checking current directory...", 2, "sweep")
If @WorkingDir = $sProgramPath Then
    $sFolder = FileSelectFolder("Please select the working directory that holds the sweep definition files.", "")
    If @error Then
        ThrowError("Could not select working directory", 1, "sweep", @error)
        Exit 2
    EndIf
    FileChangeDir($sFolder)
    If @error Then
        ThrowError("Could not access working directory", 1, "sweep", @error)
        Exit 3
    EndIf
EndIf

; Draw and show the progress meters
DrawProgressWindow()
$g_sProgressType = "both"

; Call the main run function
LogMessage("Starting preparations for parameter sweep...", 2, "sweep")
$iResult = SweepInput(@WorkingDir, $sSweepFile, $sTemplateFile, $sResultsFile, $sInputFolder)
If (Not $iResult) Or @error Then
    ThrowError("Error during parameter sweep.", 1, "sweep", @error)
    Exit 4
EndIf

; Exit program
LogMessage("Sweep complete.", 1, "sweep")
Exit
