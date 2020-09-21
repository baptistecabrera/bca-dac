# Set-SqlProjectVersion

Type: Function

Module: [Bca.Dac](../ReadMe.md)

Sets a version in a SQL Project file.
## Description
Sets a version in a SQL Project file.
## Syntax
```powershell
Set-SqlProjectVersion [-Path] <string[]> [-Version] <version> [-Recurse] [-Force] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Set-SqlProjectVersion -Path C:\MyProject\MyProject.sqlproj -Version 1.0.0
```
This example will set the version 1.0.0 to MyProject.sqlproj.
### Example 2
```powershell
Set-SqlProjectVersion -Path C:\MyProject\ -Version 1.0.0 -Recurse
```
This example will set the version 1.0.0 to all SQL Project files found recursively in C:\MyProject.
## Parameters
### `-Path`
An array of strings containing the paths to the SQL Project files or a folder containing them.

| | |
|:-|:-|
|Type:|String[]|
|Position:|0|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-Version`
A version containing the version to set.

| | |
|:-|:-|
|Type:|Version|
|Position:|1|
|Required:|True|
|Accepts pipepline input:|False|

### `-Recurse`

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Force`
A switch specifying whether or not to for the modification, for instance if the file is read-only.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

