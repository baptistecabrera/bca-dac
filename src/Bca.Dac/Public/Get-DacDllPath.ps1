function Get-DacDllPath
{
    <#
        .SYNOPSIS
            Gets the path of the DAC DLL.
        .DESCRIPTION
            Gets the path of the DAC DLL.
        .OUTPUTS
            System.String
            Returns a String containing the path to the DLL.
        .EXAMPLE
            Get-DacDllPath

            Description
            -----------
            This example will return a string containing the path to the DLL.
        .NOTES
            This function will either retrieve the path set by Set-DacDllPath, autodiscover the path from the path the PowerShell module SqlServer if present, or return an empty string.
        .LINK
            Set-DacDllPath
    #>
    [CmdletBinding()]
    param()

    Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
    if (!$script:DacDllPath)
    {
        Write-Verbose $script:LocalizedData.GetDacDllPath.Verbose.FromModule
        $SqlServerModule = Get-Module SqlServer -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
        if ($SqlServerModule)
        {
            $DacDllPath = Join-Path $SqlServerModule.ModuleBase "Microsoft.SqlServer.Dac.dll"
            if (Test-Path $DacDllPath) { Set-DacDllPath -Path $DacDllPath }
        }
    }
    $script:DacDllPath

    Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
}