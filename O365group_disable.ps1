#This script can be used to hide all unified groups (Office 365 groups) from the address list.

#This script is provided as is without any warranties. Please test this in a test environment before executin in production.

#Connect Powershell to Office 365.
$Credentials = Get-Credential
Connect-ExchangeOnline -Credential $Credentials

#=================================================================================#

#Adds all the unified groups to the varibale.
$Unified_groups = Get-UnifiedGroup -ResultSize unlimited

#Create an Empty array to add the names of groups that were modified in this script.
$modified_groups = @()

#To get the location to export the lit of modified groups to
$file_location = Read-Host -Prompt "Enter the path where you wish to save the list of modified groups."

#To keep a count of the groups being modififed in this script
$modified_counter = 0

foreach ($group in $Unified_groups)
{
    Write-Host "Working on $group"
    if ($group.HiddenFromAddressListsEnabled -eq $False)
    {
        Write-Host "$group is not hidden from GAL; hence hiding it now." -BackgroundColor DarkMagenta
        Set-UnifiedGroup -Identity $group.Identity -HiddenFromAddressListsEnabled $true
        
        $modified_groups += $group.PrimarySmtpAddress
        $modified_counter++
    
    }
    else
    {

        Write-Host "$group is already hidden from GAL." -ForegroundColor Cyan

    }
}

Write-Host "Number of groups modified: $modified_counter"

#Exports the list of modified groups to the location shared by the user.
$modified_groups >$file_location

#Launches the exported file for your perusal.
notepad $file_location