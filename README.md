# LocalAdminRemoval
 Does the following:
        Grabs ComputerList.csv located in this folder 
            You can adjust this slightly and easily grab Active Directory Computers, but make sure you know what/who is being affected!!
        Removes all Administrator users from the local group on the computer.
            Uses two different commands based on computer name and domain name, this must be done since the LocalUser commands do not look at Domain
                 PC Name is auto calculated
                eg. ABCD\ - 5 characters to remove
        Disables ALL LOCAL USERS - Depending on computer and enviroment, this could be problematic - works for my use case since I am reviewing accounts
        
