if (Test-Path (Join-Path $PSScriptRoot LocalizedData))
{
    $global:TestLocalizedData = Import-LocalizedData -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) -ErrorAction SilentlyContinue
    if (!$?) { $global:TestLocalizedData = Import-LocalizedData -UICulture en-US -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) }
}

Describe $global:TestLocalizedData.Module.Describe {
    It $global:TestLocalizedData.Module.ImportModule {
        try
        {
            Import-Module (Join-Path $PSScriptRoot Bca.Dac.psd1) -Force
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }
    
    It $global:TestLocalizedData.Module.CommandCheck {
        $Commands = Get-Command -Module Bca.Jwt
        $Commands.Count | Should -BeGreaterThan 0
    }
}