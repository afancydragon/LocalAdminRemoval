# LocalAdminRemoval

TBD - more explanaions on how this works

Contact:  
- Just add an issue if you would like this tinkered with at all or adjusted slightly for your use case  

Requirements:  
- WinRM enabled if you want to run remotely  

WARNING:  
- Make sure the exception list is not empty, it is possible to disable all local admins using this.
  - I have plans to add an logic to prevent this, but this currently works

Does the following:  
- Grabs ComputerList.csv from wherever you specify   
  - You can adjust this slightly and easily grab Active Directory Computers, make sure you know what/who is affected!  
- Removes all Administrator users from the local group on the computer.  
  - Removes all users not in the AccountExceoptionlist.csv
- Disables ALL LOCAL USERS - Depending on computer and enviroment, this could be problematic, check computers/users affected if this is a concern.  
- Adds all users stated in the addaccountlist.csv if this command is invoked as an admin/domain admin it should search AD and add them without issue.        
