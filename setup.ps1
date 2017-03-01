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
}

#Installs the additional software
Function Install-Software
{
    #support
    choco install TeamViewer -iy

    #runtimes
    choco install Silverlight -iy
    choco install flashplayerplugin -iy
    choco install javaruntime

    #browser
    choco install Firefox -iy
    choco install googlechrome -iy

    #medien
    choco install adobereader -iy
    choco install vlc -iy
    choco install itunes -iy
    choco install spotify -iy

    #utilities
    choco install dropbox -iy
}

#installs all updates
Function Install-Updates
{
    Install-Module PSWindowsUpdate -Force
    Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
    Get-WUInstall –MicrosoftUpdate –AcceptAll –AutoReboot
}

#Main Function which configures the client
Function Set-Client 
{
	param (
        [Parameter(Mandatory=$true)]
		$Hostname = ""
	)
	
    if($PSVersionTable.PSVersion.Major -ge 5)
    {
        Write-Host "powershell version test passed" -ForegroundColor Green

        if(Test-Admin)
        {
            Write-Host "adminpermission found, continue to run the script" -ForegroundColor Green

            Rename-Computer -NewName $Hostname
	
	        Install-Requirments

            Install-Software

            Install-Updates
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
}
