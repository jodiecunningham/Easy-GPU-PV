#requires -Module Hyper-V
[CmdletBinding()]
param(
[string]$vhdpath = "G:\Hyper-V\Virtual Hard Disks",
[string]$BaseVHDName = "BaseGamingData.vhdx",
[string]$HostName = (hostname),
[string]$Suffix= "-Child"
)

$VMs = Get-VM|Where-Object{ $_.HardDrives.Path -like '*$Suffix.vhdx' }
$VMs|Stop-VM 
Get-Process "TheDivision2"|Stop-Process -force

Dismount-VHD "$vhdpath\$hostName$Suffix.vhdx"

Merge-VHD -Path "$vhdpath\$hostName$Suffix.vhdx" -DestinationPath "$vhdpath\$BaseVHDName"

$VMs|get-vmharddiskdrive|? {$_.Path -like '*$Suffix.vhdx' }|ForEach-Object{ 
    $_|Remove-vmharddiskdrive
    Remove-Item "$vhdpath\$($_.VMName)$Suffix.vhdx"
    new-vhd -ParentPath "$vhdpath\$BaseVHDName" -Path "$vhdpath\$($_.VMName)$Suffix.vhdx" -Differencing
    add-vmharddiskdrive -VMName $_.VMName -Path "$vhdpath\$($_.VMName)$Suffix.vhdx"
}

.\New-BaseVHD.ps1