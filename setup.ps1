# -------------------------------------------------------------------------
# Author: James Levell
# Date: 2016-09-14
# Version: 1.0
# Comment: Configures the base client
# History:	R1	2016-09-14	Levell James	Initial Build
# --------------------------------------------------------------------------
Clear-Host

#Verify if admin permission, returns true or false
Function Test-Admin
{
	([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

#install coco lately requirment for installing additional software
Function Install-Requirments
{
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

    Start-Sleep -Seconds 10
    choco install chocolatey-core.extension 
    choco upgrade chocolatey-core.extension 

    choco upgrade all
}

#Installs the additional software
Function Install-Software
{
    #support
    choco install TeamViewer -iy

    #runtimes
    choco install Silverlight -iy
    choco install flashplayerplugin -iy
    choco install javaruntime -iy

    #browser
    choco install Firefox -iy
    choco install googlechrome -iy

    #medien
    choco install adobereader -iy
    choco install vlc -iy
    #choco install itunes -iy
    choco install spotify -iy

    #utilities
    choco install dropbox -iy
    choco install filezilla -iy
    choco install visualstudiocode -iy
    choco install winscp -iy

    #games
    choco install steam -iy
}

#installs all updates
Function Install-Updates
{
    Install-PackageProvider -Name NuGet -force
    Install-Module PSWindowsUpdate -Force
    Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
    Get-WUInstall -MicrosoftUpdate -Install -AcceptAll -AutoReboot
    Get-WUInstall -WindowsUpdate -Install -AcceptAll -AutoReboot
}

#installs all optional features
Function Install-OptionalFeatures
{
    Enable-WindowsOptionalFeature -FeatureName Windows-Defender-ApplicationGuard -All -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -All -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName TelnetClient -All -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -All -Online -NoRestart
}

#Main Function which configures the client
Function Set-Client 
{
	param (
        [Parameter(Mandatory=$true)]
		$Hostname = ""
	)
	
    $date = get-date -format 'ddMMyyyy'
    $path = "c:\temp"
    $logFile = $path + "\" + $date + ".txt"

    New-Item -Path $path -ItemType Directory -ErrorAction SilentlyContinue

    Write-host "Start Logging" >> $logFile

    Start-Transcript -Path $logFile

    if($PSVersionTable.PSVersion.Major -ge 5)
    {
        Write-Host "powershell version test passed" -ForegroundColor Green

        if(Test-Admin)
        {
            Write-Host "adminpermission found, continue to run the script" -ForegroundColor Green
            
            Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

            Rename-Computer -NewName $Hostname
	
	        Install-Requirments

            Install-Software

            Install-Updates

            Install-OptionalFeatures
        }
        else
        {
            Write-Host "you do not have administrator permission please rerun the script using them" -ForegroundColor Red
        }
    }
    else
    {
        Write-Host "not correct version of powershell installed. Requirement is 5 or greater" -ForegroundColor Red
    }

    Write-Host "Set the executionpolicy to a usefull value" -ForegroundColor Yellow

    Stop-Transcript

    explorer $path
}