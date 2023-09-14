# Load Active Directory Module (if not loaded)
Import-Module ActiveDirectory

# Parameters
$UserName = Read-Host -Prompt "Please enter the username"
$Password = ConvertTo-SecureString "YourSecurePassword123" -AsPlainText -Force
$FirstName = Read-Host -Prompt "Please enter the first name"
$LastName = Read-Host -Prompt "Please enter the last name"
$DisplayName = "$FirstName $LastName"
$UserPrincipalName = "$UserName@yourdomain.com"
$EmailAddress = Read-Host -Prompt "Please enter the email address"
$Department = Read-Host -Prompt "Please enter the department"
$Title = Read-Host -Prompt "Please enter the title"
$LogonScript = Read-Host -Prompt "Please enter the logon script path"
$SAMAccountName = $UserName
$OU = "OU=Users,DC=yourdomain,DC=com"  # Please replace with the correct OU
$Groups = "Group1", "Group2"  # Replace with your group names

# Create the AD user
New-ADUser -Name $DisplayName -GivenName $FirstName -Surname $LastName -UserPrincipalName $UserPrincipalName -SamAccountName $SAMAccountName -EmailAddress $EmailAddress -Department $Department -Title $Title -AccountPassword $Password -Enabled $true -DisplayName $DisplayName -Path $OU -PassThru

# Set the logon script
Set-ADUser -Identity $SAMAccountName -ScriptPath $LogonScript

# Add the user to the specified groups
foreach ($Group in $Groups) {
    Add-ADGroupMember -Identity $Group -Members $SAMAccountName -PassThru
}

# Retrieve the 'MemberOf' attribute
$UserDetails = Get-ADUser -Identity $SAMAccountName -Properties "MemberOf"
$UserDetails.MemberOf
