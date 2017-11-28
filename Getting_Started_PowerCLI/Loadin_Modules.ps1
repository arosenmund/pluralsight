#Power CLI 6.x
##checking for vmware commands
function vmware-commands
{
$commands = 
get-command |where {($_.Module -like "Vmware*")};
$commands
$commands.count
}

get-module -ListAvailable

#function to add modules to environment path PSModulePath for global use
function add-vmwareModules
{
$p = [Environment]::GetEnvironmentVariable("PSModulePath")

$p += ";C:\Program Files (x86)\Vmware\Infrastructure\vSphere PowerCLI\Modules\"

[Environment]::SetEnvironmentVariable("PSModulePath",$p)

}

#importing the module available in path
import-module VMware.VimAutomation.Core