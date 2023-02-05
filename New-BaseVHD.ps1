#requires -Module Hyper-V
[CmdletBinding()]
param(
[string]$vhdpath = "G:\Hyper-V\Virtual Hard Disks",
[string]$BaseVHDName = "BaseGamingData.vhdx",
[string]$HostName = (hostname),
[string]$Suffix= "-Child",
[uint64]$DiskSize = 256GB
)

if (-not(test-path "$vhdpath\$BaseVHDName" )) {
    New-VHD -Path "$vhdpath\$BaseVHDName" -SizeBytes $DiskSize -Dynamic
}

if ((test-path "$vhdpath\$BaseVHDName" ) -and -not(test-path "$vhdpath\$hostName$Suffix.vhdx")){
    New-VHD -ParentPath "$vhdpath\$BaseVHDName" -Path "$vhdpath\$hostName$Suffix.vhdx" -Differencing 
}

if ((test-path "$vhdpath\$hostName$Suffix.vhdx") -and ((get-vhd -Path "$vhdpath\$hostName$Suffix.vhdx").Attached -eq $False)) {
    Mount-VHD -Path "$vhdpath\$hostName$Suffix.vhdx" 
}