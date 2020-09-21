function Set-DacDllPath
{
    <#
        .SYNOPSIS
            Sets the path of the DAC DLL.
        .DESCRIPTION
            Sets the path of the DAC DLL.
        .PARAMETER Path
            A string containing the path to either the directory where the DLL is located, or the path to the DLL
        .EXAMPLE
            Set-DacDllPath -Path "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll"

            Description
            -----------
            This example will return set the DLL path to "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll".
        .LINK
            Get-DacDllPath
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ } )]
        [string] $Path
    )

    try
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
        $DllPath = Get-Item $Path
        if ($DllPath.PSIsContainer)
        {
            Write-Verbose ($script:LocalizedData.SetDacDllPath.Verbose.FromDirectory -f $DllPath.FullName)
            $DacDllPath = Join-Path $DllPath.FullName "Microsoft.SqlServer.Dac.dll"
            if ((Test-Path $DacDllPath)) { $script:DacDllPath = $DacDllPath }
            else { Write-Error -Message ($script:LocalizedData.SetDacDllPath.Error.NotFound.Message -f $DllPath.FullName) -Category ObjectNotFound -CategoryActivity $MyInvocation.MyCommand -TargetType $script:LocalizedData.SetDacDllPath.Error.NotFound.Target -TargetName $DllPath.FullName -Exception ObjectNotFoundException }
        }
        elseif ($DllPath.Extension -eq ".dll") { $script:DacDllPath = $DllPath.FullName }
        else { Write-Error -Message ($script:LocalizedData.SetDacDllPath.Error.NotValid.Message -f $DllPath.FullName) -Category InvalidData -CategoryActivity $MyInvocation.MyCommand -TargetType $script:LocalizedData.SetDacDllPath.Error.NotValid.Target -TargetName $DllPath.FullName -Exception InvalidDataException }
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