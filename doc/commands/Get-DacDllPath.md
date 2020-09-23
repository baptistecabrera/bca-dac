# Get-DacDllPath

Type: Function

Module: [Bca.Dac](../ReadMe.md)

Gets the path of the DAC DLL.
## Description
Gets the path of the DAC DLL.
## Syntax
```powershell
Get-DacDllPath [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Get-DacDllPath
```
This example will return a string containing the path to the DLL.
## Parameters
## Outputs
**System.String**

Returns a String containing the path to the DLL.
## Notes
This function will either retrieve the path set by Set-DacDllPath, autodiscover the path from the path the PowerShell module SqlServer if present, or return an empty string.
## Related Links
- [Set-DacDllPath](Set-DacDllPath.md)
