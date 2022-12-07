
#update this to wherever your csv is usin FQN or similar name
$config_csv = Import-Csv -Path "\\path\to\your\csv.csv"
$domain_name = "ABCD" #No \ it is added already 
$Account = Get-Credential


 $config_csv.ComputerList | ForEach-Object {
    Invoke-Command -ComputerName $_ -ScriptBlock {
        Get-LocalGroupMember -Group "Administrators" | ForEach-Object {

            #removes domain name from string. Local User function doesn't search AD
            #2nd command is to attempt in case the returned account is local PC
            Remove-LocalGroupMember -Group "Administrators" -Member $_.Name.Remove(0,$using:domain_name.length+1)
            Remove-LocalGroupMember -Group "Administrators" -Member $_.Name.Remove(0,$_.length+1)
        }

        #Disables ALL local accounts - this could interfere if someone has very specific setups where they have multiple local accounts
        Get-LocalUser | Disable-LocalUser
        
        #Removing old account, creating, and Enabling if for some reason it is disabled
        Remove-LocalUser -Name $using:Account.UserName
        New-LocalUser -Name $using:Account.UserName -Password $using:Account.Password
        Enable-LocalUser -Name $using:Account.UserName

        #Adding all Admin roles/accounts we want
        Add-LocalGroupMember -Group "Administrators" -Member $using:Account.UserName
        $using:config_csv.AdminList | ForEach-Object {
            Add-LocalGroupMember -Group "Administrators" -Name $_
        }          
    }
}

