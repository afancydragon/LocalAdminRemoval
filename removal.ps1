
#update this to wherever your csv is usin FQN or similar name
$computer_csv = Import-Csv -Path "\\path to ur csvformatted like the example\computerlist.csv"
$add_account_csv = Import-Csv -Path "\\path to ur csvformatted like the example\addaccountlist.csv"
$exception_csv = Import-Csv -Path "\\path to ur csvformatted like the example\accountexceptionlist.csv"
$Account = Get-Credential

if(1 -eq 1){
    $computer_csv | ForEach-Object {
        Invoke-Command -ComputerName $_.Computers -ScriptBlock {
            Get-LocalGroupMember -Group "Administrators" | ForEach-Object {
                #removes all local group member from Administrators group
                $search = $_.Name
                $using:exception_csv | ForEach-Object{
                    $exceptu = $_.Exceptions   
                    If($search -like "*"+$exceptu){
                        $match = 1
                    }
                }
                if($match -ne 1 ){
                    Remove-LocalGroupMember -Group "Administrators" -Member $search
                }
                $search = $match = $null
            }

            #DISABLES ALL LOCAL ACCOUNTS - this will cause issues when used improperly.
            Get-LocalUser | Disable-LocalUser

            #Removing old account, creating, and Enabling if for some reason it is disabled
            Remove-LocalUser -Name $using:Account.UserName
            New-LocalUser -Name $using:Account.UserName -Password $using:Account.Password
            Enable-LocalUser -Name $using:Account.UserName

            #Adding all Admin roles/accounts we want
            Add-LocalGroupMember -Group "Administrators" -Member $using:Account.UserName
            $using:add_account_csv | ForEach-Object {
                Add-LocalGroupMember -Group "Administrators" -Member $_.AddAccounts
            }          
        }
    }
}

