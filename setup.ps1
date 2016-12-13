# -------------------------------------------------------------------------
# Author: James Levell
# Date: 2016-09-14
# Version: 1.0
# Comment: Configures the base client
# History:	R1	2016-09-14	Levell James	Initial Build
# --------------------------------------------------------------------------
cls

#Verify if admin permission, returns true or false
Function Verify-Admin
{
	([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

#install coco lately requirment for installing additional software
Function Install-Requirments
{
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

#Installs the additional software
Function Install-Software
{
    choco install TeamViewer -iy
    choco install Silverlight -iy
    choco install Firefox -iy
    choco install flashplayerplugin -iy
    choco install googlechrome -iy
    choco install adobereader -iy
    choco install vlc -iy
    choco install dropbox -iy
    choco install itunes -iy
    choco install spotify -iy
}

#installs all updates
Function Install-Updates
{
    Install-Module PSWindowsUpdate
    Get-WUInstall –MicrosoftUpdate –AcceptAll –AutoReboot
}

#Main Function which configures the client
Function Configure-Client 
{
	param (
        [Parameter(Mandatory=$true)]
		$Hostname = ""
	)
	
    if($PSVersionTable.PSVersion.Major -ge 5)
    {
        Write-Host "powershell version test passed" -ForegroundColor Green

        if(Verify-Admin)
        {
            Write-Host "adminpermission found, continue to run the script" -ForegroundColor Green

            Rename-Computer -NewName $Hostname
	
	       Install-Requirments

           Install-Software
        }
        else
        {
            Write-Host "you do not have administrator permission please rerun the script using them" -ForegroundColor Red
        }
    }
    else
    {
        Write-Host "not correct version of powershell installed 5 min" -ForegroundColor Red
    }
}
