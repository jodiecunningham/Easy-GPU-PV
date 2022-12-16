#requires -Module Hyper-V
[CmdletBinding()]
param(
[string]$GPUName = "AUTO"
)

get-vm|ForEach-Object{ 
    Get-VMGpuPartitionAdapter -VMName $_.VMName }|ForEach-Object{ 
        .\Update-VMGpuPartitionDriver.ps1 -VMName $_.VMName -GPUName $GPUName }