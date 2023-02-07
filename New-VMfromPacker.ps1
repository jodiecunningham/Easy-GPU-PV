#requires -Module Hyper-V
[CmdletBinding()]
param(
[string]$HostName = (hostname),
[int64]$Mem = 4294967296,
[int]$CPUs = 4,
[string]$VMPath = "G:\Hyper-V\Virtual Machines",
[string]$VHDDestinationPath = "G:\Hyper-V\Virtual Hard Disks",
[string]$SourceVMCXPath = "G:\Hyper-V\packer\windows_11\Virtual Machines\C82F4FF2-7E7F-4009-91C0-0995AEC65063.vmcx",
[string]$SwitchName = "hyperv0",
[string]$VMName = "ProVM",
[string]$GPUName = "AMD Radeon RX 6900 XT",
[string]$GPUPercent = "20"
)

import-module .\Add-VMGPUPartitionAdapterPercentage.psm1
import-module .\Add-VMGPUPartitionAdapterFiles.psm1
import-module .\Update-VMGPUPartitionDriver.ps1

$VMPath = "$VMPath\$VMName"
$VHDDestinationPath = "$VHDDestinationPath\$VMName"
Import-VM -Path $SourceVMCXPath -VhdDestinationPath $VHDDestinationPath -VirtualMachinePath $VMPath -Copy -GenerateNewId 
$vm = Get-VM|Where-Object {$_.Path.StartsWith($VMPath)}
Rename-VM -VM $vm -NewName $VMName
Set-VM -VM $vm -ProcessorCount $CPUs -CheckpointType Disabled -LowMemoryMappedIoSpace 3GB -HighMemoryMappedIoSpace 32GB -GuestControlledCacheTypes $true -AutomaticStopAction ShutDown
Set-VMMemory -VM $vm -DynamicMemoryEnabled $False -StartupBytes $Mem 
Set-VMHost -ComputerName $HostName -EnableEnhancedSessionMode $false
Set-VMVideo -VM $vm -HorizontalResolution 1920 -VerticalResolution 1080
Set-VMKeyProtector -VM $vm -NewLocalKeyProtector
Enable-VMTPM -VM $vm
Add-VMGPUPartitionAdapterPercentage -VMName $vm.VMName -GPUName $GPUName -GPUResourceAllocationPercentage $GPUPercent
Update-VMGPUPartitionDriver -VMName $vm.VMName -GPUName $GPUName

Start-VM -VM $vm  
vmconnect.exe localhost $vm.VMName