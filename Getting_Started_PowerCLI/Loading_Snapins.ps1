# PowerCLI 5.X
function vmware-commands 
{
$commands = 
get-command |where {($_.ModuleName -like "vmware*")};
$commands
$commands.count
}


Add-PSSnapin vmware.vimautomation.core

Remove-PSSnapin vmware.vimautomation.core


###list registered snappins
Get-PSSnapin -Registered |ft



