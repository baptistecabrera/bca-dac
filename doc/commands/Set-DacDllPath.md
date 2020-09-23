# Set-DacDllPath

Type: Function

Module: [Bca.Dac](../ReadMe.md)

Sets the path of the DAC DLL.
## Description
Sets the path of the DAC DLL.
## Syntax
```powershell
Set-DacDllPath [-Path] <string> [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Set-DacDllPath -Path "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll"
```
This example will return set the DLL path to "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll".
## Parameters
### `-Path`
A string containing the path to either the directory where the DLL is located, or the path to the DLL

| | |
|:-|:-|
|Type:|String|
|Position:|0|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

## Related Links
- [Get-DacDllPath](Get-DacDllPath.md)
