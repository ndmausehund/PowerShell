# Script for bulk add users to ad groups
#Import csv file and loads adusers in variable

$Users = Import-Csv -Path "C:\ScriptOutput\nameadd.csv"

#Iterate AdUsers to add user account in Group

foreach($User in $Users){
        try
        {

            Add-ADGroupMember -Identity GroupName -Members $User.User -ErrorAction Stop -Verbose
        }
        catch
        {
            Write-Host "Error while adding user to adgroup"
        }

    }