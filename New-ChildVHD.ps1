#requires -Module Hyper-V
[CmdletBinding()]
param(
[string]$vhdpath = "G:\Hyper-V\Virtual Hard Disks",
[string]$BaseVHDName = "BaseGamingData.vhdx",
[string]$VMName = (hostname),
[string]$Suffix= "-Child",
[uint64]$DiskSize = 256GB
)

if ((test-path "$vhdpath\$BaseVHDName") -and -not(test-path "$vhdpath\$VMName$Suffix.vhdx") ) {
    New-VHD -ParentPath "$vhdpath\$BaseVHDName" -Path "$vhdpath\$VMName$Suffix.vhdx" -Differencing
    add-vmharddiskdrive -VMName $VMName -Path "$vhdpath\$($VMName)$Suffix.vhdx"
}
