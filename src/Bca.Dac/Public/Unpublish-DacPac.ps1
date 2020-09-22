function Unpublish-DacPac
{
    <#
        .SYNOPSIS
            Unpublishes a DAC package.
        .DESCRIPTION
            Unpublishes a DAC package.
        .PARAMETER Path
            A string containing the path to the DAC package.
        .PARAMETER DacProfilePath
            A string containing the path to the DAC profile.
        .PARAMETER DeployOptions
            A hashtable containing the deployment options to use.
        .PARAMETER Mode
            A string containing the mode used to unregister the DAC package.
        .PARAMETER DacDllPath
            A string containing the path to the DAC DLL.
        .PARAMETER KillSessions
            A switch specifying whether or not to terminate active session on the database if it exists.
        .PARAMETER Force
            A switch specifying whether or not to force the execution (will implicitely enable option KillSessions).
        .EXAMPLE
            Unpublish-DacPac -Path C:\MyProject\MyProject.dacpac -DacProfilePath C:\MyProject\MyProject.publish.xml

            Description
            -----------
            This example will undeploy MyProject.dacpac based on the publish profile MyProject.publish.xml.
        .LINK
            Publish-DacPac
    #>
    [CmdLetBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ } )]
        [alias("DacPacPath")]
        [string] $Path,
        [parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ } )]
        [string] $DacProfilePath,
        [parameter(Mandatory = $false)]
        [ValidateSet("UnregisterDac", "DetachDatabase", "DropDatabase")]
        [alias("DacUninstallMode", "UninstallMode")]
        [string] $Mode = "UnregisterDac",
        [ValidateScript( { Test-Path $_ } )]
        [string] $DacDllPath = (Get-DacDllPath),
        [parameter(Mandatory = $false)]
        [switch] $KillSessions,
        [Parameter(Mandatory = $false)]
        [switch] $Force
    )

    try
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)

        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadDll -f $DacDllPath)
        Add-Type -Path $DacDllPath

        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadProfile -f $DacProfilePath)
        $DacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load($DacProfilePath)
        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadPackage -f $Path)
        $DacPac = [Microsoft.SqlServer.Dac.DacPackage]::Load($Path)
        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadService -f $DacProfile.TargetConnectionString)
        $DacService = New-Object Microsoft.SqlServer.Dac.DacServices $DacProfile.TargetConnectionString

        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.TstDb -f $DacProfile.TargetDatabaseName)
        Write-Debug $DacProfile.TargetConnectionString
        try
        {
            $DbId = Invoke-Sqlcmd -ConnectionString $DacProfile.TargetConnectionString -Query "SELECT DB_ID('$($DacProfile.TargetDatabaseName)') AS [Id]" -ErrorAction SilentlyContinue
            if ($DbId.Id -eq [DBNull]::Value) { $DbExists = $false }
            else { $DbExists = $true }
        }
        catch
        {
            $DbExists = $false
        }
        Write-Debug $DbExists
        
        if ($DbExists)
        {
            if ($KillSessions)
            {
                Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.KillSessions -f $DacProfile.TargetDatabaseName)
                try { Invoke-Sqlcmd -ConnectionString $DacProfile.TargetConnectionString -Query "DECLARE @SQL nvarchar(1000); SELECT @SQL = COALESCE(@SQL,'') + 'KILL ' + Convert(varchar, session_id) + ';' FROM sys.dm_exec_sessions WHERE database_id = DB_ID('$($DacProfile.TargetDatabaseName)') AND session_id > 8 AND session_id <> @@SPID; EXEC (@SQL)" | Out-Null }
                catch { Write-Warning ($script:LocalizedData.PublishUnpublishDacPac.Warning.CantKillSessions -f $DacProfile.TargetDatabaseName) }
            }

            Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.UnregisterDac -f $DacPac.Name, $Mode)
            if ($Force -or $PSCmdlet.ShouldProcess($DacProfile.TargetDatabaseName))
            { 
                $DacService.Unregister($DacProfile.TargetDatabaseName)
                switch ($Mode)
                {
                    "DetachDatabase" { Invoke-Sqlcmd -ConnectionString $DacProfile.TargetConnectionString -Query "EXEC sp_detach_db $($DacProfile.TargetDatabaseName);" | Out-Null }
                    "DropDatabase" { Invoke-Sqlcmd -ConnectionString $DacProfile.TargetConnectionString -Query "DROP DATABASE $($DacProfile.TargetDatabaseName);" | Out-Null }
                }
            }
        }
        else { Write-Warning ($script:LocalizedData.PublishUnpublishDacPac.Warning.DbDoesntExist -f $DacProfile.TargetDatabaseName) }
    }
    catch
    {
        Write-Error $_
    }
    finally
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
    }
}