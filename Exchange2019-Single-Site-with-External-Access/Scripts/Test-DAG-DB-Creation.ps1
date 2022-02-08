$ConfigDC = "khl-dc-01"
$Site1DC = "khl-dc-01"
$Site2DC = "khl-dc-02"
$BaseDN = "DC=dir,DC=ad,DC=killerhomelab,DC=com"
$InternalDomainName = "dir.ad.killerhomelab.com"
$computerName = "khl-ex19-01"
$PassiveDAGNode = "khl-ex19-02"
$DAGName = "khl-19-dag01"
$DB1Name = "khl-19-db01"
$DB2Name = "khl-19-db02"
$Site1FSW = "khl-fs-01"

repadmin /replicate "$Site1DC" "$Site2DC" "$BaseDN"
repadmin /replicate "$Site2DC" "$Site1DC" "$BaseDN"

# Connect to Exchange
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$computerName.$InternalDomainName/PowerShell/"
Import-PSSession $Session

# Create DAG
$DAGCheck = Get-DatabaseAvailabilityGroup -Identity "$DAGName" -DomainController "$ConfigDC" -ErrorAction 0
IF ($DAGCheck -eq $null) {
New-DatabaseAvailabilityGroup -Name "$DAGName" -WitnessServer "$Site1FSW" -WitnessDirectory C:\FSWs -DomainController "$ConfigDC"
Add-DatabaseAvailabilityGroupServer -Identity "$DAGName" -MailboxServer "$computerName" -DomainController "$ConfigDC"
Add-DatabaseAvailabilityGroupServer -Identity "$DAGName" -MailboxServer "$PassiveDAGNode" -DomainController "$ConfigDC"
}

repadmin /replicate "$Site1DC" "$Site2DC" "$BaseDN"
repadmin /replicate "$Site2DC" "$Site1DC" "$BaseDN"

# Create Database Copies
$DB1CopyCheck = Get-MailboxDatabase -Server "$PassiveDAGNode" | Where-Object {$_.Name -like "$DB1Name"}
IF ($DB1CopyCheck -eq $null) {Add-MailboxDatabaseCopy -Identity "$using:DB1Name" -MailboxServer "$PassiveDAGNode"}

$DB2CopyCheck = Get-MailboxDatabase -Server "$ComputerName" | Where-Object {$_.Name -like "$DB2Name"}
IF ($DB2CopyCheck -eq $null) {Add-MailboxDatabaseCopy -Identity "$DB2Name" -MailboxServer "$ComputerName"}