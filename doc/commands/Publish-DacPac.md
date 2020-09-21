# Publish-DacPac

Type: Function

Module: [Bca.Dac](../ReadMe.md)

Publishes a DAC package.
## Description
Publishes a DAC package.
## Syntax
```powershell
Publish-DacPac [-Path] <string> [-DacProfilePath] <string> [[-DeployOptions] <hashtable>] [[-OutputPath] <string>] [[-DacDllPath] <string>] [-GenerateDriftReport] [-GenerateDeployReport] [-GenerateDeployScript] [-KillSessions] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Publish-DacPac -Path C:\MyProject\MyProject.dacpac -DacProfilePath C:\MyProject\MyProject.publish.xml
```
This example will deploy MyProject.dacpac based on the publish profile MyProject.publish.xml.
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
|Aliases|PublishProfilePath|
|Position:|1|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-DeployOptions`
A hashtable containing the deployment options to use.

| | |
|:-|:-|
|Type:|Hashtable|
|Position:|2|
|Required:|False|
|Accepts pipepline input:|False|

### `-GenerateDriftReport`
A switch specifying whether or not to generate a drift report.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-GenerateDeployReport`
A switch specifying whether or not to generate a deployment report.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-GenerateDeployScript`
A switch specifying whether or not to generate a deployment script.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-OutputPath`
A string containing the path where the reports and scripts will be saved.

| | |
|:-|:-|
|Type:|String|
|Aliases|OutputDirectory, OutputDir, OutDir|
|Default value:|([System.IO.Path]::GetTempPath())|
|Position:|3|
|Required:|False|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-DacDllPath`
A string containing the path to the DAC DLL.

| | |
|:-|:-|
|Type:|String|
|Default value:|(Get-DacDllPath)|
|Position:|4|
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

## Related Links
- [Unpublish-DacPac](Unpublish-DacPac.md)
