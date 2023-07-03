# o365-powershell-getallnormreevesaliases
PowerShell script that queries all user and shared mailboxes from Exchange Online for all @normreeves.com aliases (not primary username) that also have a period (.) in the user name.

Outputs in format for "Connect to AD" provisioning user logon name rules.

"Connect to AD" provisioning user logon name rule example:
=========
string[] aliases = {"john.doe1@test.com", "john.doe2@test.com", "john.doe3@test.com", "john.doe4@test.com"};

aliases.Contains(Person.PreferredName + '.' + Person.LastName)? "":Person.PreferredName + '.' + Person.LastName;

Important to Note:
=========
• Script/.exe does not need to be elevated to work unless ExchangeOnlineManagement module is not installed.

Download .exe
=========


Change Log:
============
1.0:

  • Created base script.
