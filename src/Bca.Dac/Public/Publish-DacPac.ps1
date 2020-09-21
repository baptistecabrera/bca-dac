function Publish-DacPac
{
    <#
        .SYNOPSIS
            Publishes a DAC package.
        .DESCRIPTION
            Publishes a DAC package.
        .PARAMETER Path
            A string containing the path to the DAC package.
        .PARAMETER DacProfilePath
            A string containing the path to the DAC profile.
        .PARAMETER DeployOptions
            A hashtable containing the deployment options to use.
        .PARAMETER GenerateDriftReport
            A switch specifying whether or not to generate a drift report.
        .PARAMETER GenerateDeployReport
            A switch specifying whether or not to generate a deployment report.
        .PARAMETER GenerateDeployScript
            A switch specifying whether or not to generate a deployment script.
        .PARAMETER OutputPath
            A string containing the path where the reports and scripts will be saved.
        .PARAMETER DacDllPath
            A string containing the path to the DAC DLL.
        .PARAMETER KillSessions
            A switch specifying whether or not to terminate active session on the database if it exists.
        .EXAMPLE
            Publish-DacPac -Path C:\MyProject\MyProject.dacpac -DacProfilePath C:\MyProject\MyProject.publish.xml

            Description
            -----------
            This example will deploy MyProject.dacpac based on the publish profile MyProject.publish.xml.
        .LINK
            Unpublish-DacPac
    #>
    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ } )]
        [alias("DacPacPath")]
        [string] $Path,
        [parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ } )]
        [alias("PublishProfilePath")]
        [string] $DacProfilePath,
        [parameter(Mandatory = $false)]
        [hashtable] $DeployOptions,
        [parameter(Mandatory = $false)]
        [switch] $GenerateDriftReport,
        [parameter(Mandatory = $false)]
        [switch] $GenerateDeployReport,
        [parameter(Mandatory = $false)]
        [switch] $GenerateDeployScript,
        [parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path $_ } )]
        [alias("OutputDirectory", "OutputDir", "OutDir")]
        [string] $OutputPath = ([System.IO.Path]::GetTempPath()),
        [parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path $_ } )]
        [string] $DacDllPath = (Get-DacDllPath),
        [parameter(Mandatory = $false)]
        [switch] $KillSessions
    )

    try
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)

        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadDll -f $DacDllPath)
        Add-Type -Path $DacDllPath

        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadProfile -f $DacProfilePath)
        $DacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load($DacProfilePath)
        $DeployOptions.Keys | ForEach-Object {
            try 
            {
                Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.DeployOption -f $_, $DeployOptions[$_])
                $DacProfile.DeployOptions.$_ = $DeployOptions[$_]
            }
            catch
            {
                Write-Error $_
            }
        }
        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadService -f $DacProfile.TargetConnectionString)
        $DacService = New-Object Microsoft.SqlServer.Dac.DacServices $DacProfile.TargetConnectionString
        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.LoadPackage -f $Path)
        $DacPac = [Microsoft.SqlServer.Dac.DacPackage]::Load($Path)

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
            if ($GenerateDriftReport)
            {
                Write-Verbose $script:LocalizedData.PublishUnpublishDacPac.Verbose.DriftReport
                $DacService.GenerateDriftReport($DacProfile.TargetDatabaseName) | Out-File (Join-Path $OutputPath "$($DacProfile.TargetDatabaseName).DriftReport.xml")
            }
            else { Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.NoDriftReport -f $DacProfile.TargetDatabaseName) }
            if ($KillSessions)
            {
                Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.KillSessions -f $DacProfile.TargetDatabaseName)
                try { Invoke-Sqlcmd -ConnectionString $DacProfile.TargetConnectionString -Query "DECLARE @SQL nvarchar(1000); SELECT @SQL = COALESCE(@SQL,'') + 'KILL ' + Convert(varchar, session_id) + ';' FROM sys.dm_exec_sessions WHERE database_id = DB_ID('$($DacProfile.TargetDatabaseName)') AND session_id > 8 AND session_id <> @@SPID; EXEC (@SQL)" | Out-Null }
                catch { Write-Warning ($script:LocalizedData.PublishUnpublishDacPac.Warning.CantKillSessions -f $DacProfile.TargetDatabaseName) }
            }
        }
        else { Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.NoDriftReport -f $DacProfile.TargetDatabaseName) }

        if ($GenerateDeployReport)
        {
            Write-Verbose $script:LocalizedData.PublishUnpublishDacPac.Verbose.DeployReport
            $DacService.GenerateDeployReport($DacPac, $DacProfile.TargetDatabaseName, $DacProfile.DeployOptions) | Out-File (Join-Path $OutputPath "$($DacProfile.TargetDatabaseName).DeployReport.xml")
        }
        if ($GenerateDeployScript)
        {
            Write-Verbose $script:LocalizedData.PublishUnpublishDacPac.Verbose.DeployScript
            $DacService.GenerateDeployScript($DacPac, $DacProfile.TargetDatabaseName, $DacProfile.DeployOptions) | Out-File (Join-Path $OutputPath "$($DacProfile.TargetDatabaseName).DeployScript.sql")
        }

        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.DeployDacPac -f $DacPac.Name)
        $DacService.Deploy($DacPac, $DacProfile.TargetDatabaseName, $true, $DacProfile.DeployOptions)
    }
    catch
    {
        Write-Error $_
    }
    finally
    {
        Write-Verbose ($script:LocalizedData.PublishUnpublishDacPac.Verbose.ReportPath -f $OutputPath)
        Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
    }
}