function Set-SqlProjectVersion
{
    <#
        .SYNOPSIS
            Sets a version in a SQL Project file.
        .DESCRIPTION
            Sets a version in a SQL Project file.
        .PARAMETER Path
            An array of strings containing the paths to the SQL Project files or a folder containing them.
        .PARAMETER Version
            A version containing the version to set.
        .PARAMETER Rescurse
            A switch specifying whether or not to look recursively for SQL Project files if Path is a directory.
        .PARAMETER Force
            A switch specifying whether or not to for the modification, for instance if the file is read-only.
        .EXAMPLE
            Set-SqlProjectVersion -Path C:\MyProject\MyProject.sqlproj -Version 1.0.0

            Description
            -----------
            This example will set the version 1.0.0 to MyProject.sqlproj.
        .EXAMPLE
            Set-SqlProjectVersion -Path C:\MyProject\ -Version 1.0.0 -Recurse

            Description
            -----------
            This example will set the version 1.0.0 to all SQL Project files found recursively in C:\MyProject.
    #>
    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ })]
        [string[]] $Path,
        [parameter(Mandatory = $true)]
        [version] $Version,
        [parameter(Mandatory = $false)]
        [switch] $Recurse,
        [parameter(Mandatory = $false)]
        [switch] $Force
    )

    try 
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
        $SqlProjs = @()
        $Path | ForEach-Object {
            $Item = Get-Item -Path $_
            if ($Item.PSIsContainer)
            {
                Write-Verbose ($script:LocalizedData.SetSqlProjectVersion.Verbose.Directory -f $Item.FullName, $Recurse)
                $SqlProjs += (Get-ChildItem -Path $Item.FullName -Recurse:$Recurse -Include *.sqlproj).FullName
            }
            elseif ($Item.Extension -eq ".sqlproj")
            {
                Write-Verbose ($script:LocalizedData.SetSqlProjectVersion.Verbose.File -f $Item.FullName)
                $SqlProjs += $Item.FullName
            }
            else { Write-Warning ($script:LocalizedData.SetSqlProjectVersion.Warning.NotSqlProj -f $Item.FullName) }
        }
    
        $SqlProjs | Sort-Object -Unique | Get-Unique | ForEach-Object {
            try
            {
                Write-Verbose ($script:LocalizedData.SetSqlProjectVersion.Verbose.ProcessFile -f $_)
                if ($Force)
                {
                    Write-Verbose $script:LocalizedData.SetSqlProjectVersion.Verbose.ROFlag
                    Set-ItemProperty $_ -Name IsReadOnly -Value $false
                }
                $Xml = [xml](Get-Content $_)
                $Xml.Project.PropertyGroup | ForEach-Object {
                    if ($_.DacVersion) { $_.DacVersion = $Version.ToString() }
                }
                $Xml.Save($_)
                Write-Verbose ($script:LocalizedData.SetSqlProjectVersion.Verbose.VersionUpdated -f $Version.ToString(), $_)
            }
            catch
            {
                Write-Error $_
            }
        }

    }
    catch
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
    }
    finally
    {

    }
}