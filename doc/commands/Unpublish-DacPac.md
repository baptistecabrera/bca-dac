# Unpublish-DacPac

Type: Function

Module: [Bca.Dac](../ReadMe.md)

Unpublishes a DAC package.
## Description
Unpublishes a DAC package.
## Syntax
```powershell
Unpublish-DacPac [-Path] <string> [-DacProfilePath] <string> [[-Mode] <string>] [[-DacDllPath] <string>] [-KillSessions] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Unpublish-DacPac -Path C:\MyProject\MyProject.dacpac -DacProfilePath C:\MyProject\MyProject.publish.xml
```
This example will undeploy MyProject.dacpac based on the publish profile MyProject.publish.xml.
## Parameters
### `-Path`
A string containing the path to the DAC package.

| | |
|:-|:-|
|Type:|String|
|Aliases|DacPacPath|
|Position:|0|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-DacProfilePath`
A string containing the path to the DAC profile.

| | |
|:-|:-|
|Type:|String|
|Position:|1|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-Mode`
A string containing the mode used to unregister the DAC package.

| | |
|:-|:-|
|Type:|String|
|Aliases|DacUninstallMode, UninstallMode|
|Default value:|UnregisterDac|
|Position:|2|
|Required:|False|
|Accepts pipepline input:|False|
|Validation (ValidValues):|UnregisterDac, DetachDatabase, DropDatabase|

### `-DacDllPath`
A string containing the path to the DAC DLL.

| | |
|:-|:-|
|Type:|String|
|Default value:|(Get-DacDllPath)|
|Position:|3|
|Required:|False|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-KillSessions`
A switch specifying whether or not to terminate active session on the database if it exists.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Force`
A switch specifying whether or not to force the execution (will implicitely enable option KillSessions).

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

## Related Links
- [Publish-DacPac](Publish-DacPac.md)
