Remove-MailboxDatabaseCopy khl-19-db02\khl-ex19-01 -Confirm:$False
Remove-MailboxDatabaseCopy khl-19-db01\khl-ex19-02 -Confirm:$False
repadmin /replicate khl-dc-01 khl-dc-02 "DC=dir,DC=ad,DC=killerhomelab,DC=com"
Remove-DatabaseAvailabilityGroupServer -Identity khl-19-dag01 -MailboxServer khl-ex19-01 -Confirm:$False
Remove-DatabaseAvailabilityGroupServer -Identity khl-19-dag01 -MailboxServer khl-ex19-02 -Confirm:$False
repadmin /replicate khl-dc-01 khl-dc-02 "DC=dir,DC=ad,DC=killerhomelab,DC=com"
Remove-DatabaseAvailabilityGroup -Identity khl-19-dag01 -Confirm:$False