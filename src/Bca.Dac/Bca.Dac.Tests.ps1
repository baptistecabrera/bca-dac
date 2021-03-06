if (Test-Path (Join-Path $PSScriptRoot LocalizedData))
{
    $global:TestLocalizedData = Import-LocalizedData -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) -ErrorAction SilentlyContinue
    if (!$?) { $global:TestLocalizedData = Import-LocalizedData -UICulture en-US -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) }
}

Describe $global:TestLocalizedData.Module.Describe {
    BeforeAll {
        $ParentDirectory = Split-Path $PSScriptRoot -Parent
        $Directory = Split-Path $PSScriptRoot -Leaf

        if ([version]::TryParse($Directory, [ref]$null)) { $ModuleName = Split-Path $ParentDirectory -Leaf }
        else { $ModuleName = $Directory }
    }

    It $global:TestLocalizedData.Module.ImportModule {
        try
        {
            Import-Module (Join-Path $PSScriptRoot ("{0}.psd1" -f $ModuleName)) -Force
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }
    
    It $global:TestLocalizedData.Module.CommandCheck {
        $Commands = Get-Command -Module $ModuleName
        $Commands.Count | Should -BeGreaterThan 0
    }
}

Describe $global:TestLocalizedData.DllPath.Describe {
    BeforeAll {
        $SqlServerModule = $SqlServerModule = Get-Module SqlServer -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
        if (!$SqlServerModule)
        {
            Find-Module SqlServer | Install-Module -Scope CurrentUser -Force
            $SqlServerModule = $SqlServerModule = Get-Module SqlServer -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
        }
        $DacDllPath = Join-Path $SqlServerModule.ModuleBase "Microsoft.SqlServer.Dac.dll"
        $NotDacDllPath = Join-Path ([System.IO.Path]::GetTempPath()) "Microsoft.SqlServer.Dac.notdll"
    }

    It $global:TestLocalizedData.DllPath.GetDllModule {
        try
        {
            $DllPath = Get-DacDllPath
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $DllPath | Should -BeExactly $DacDllPath
    }
    
    It $global:TestLocalizedData.DllPath.SetDllFullPath {
        try
        {
            Set-DacDllPath -Path $DacDllPath
            $DllPath = Get-DacDllPath
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $DllPath | Should -BeExactly $DacDllPath
    }

    It $global:TestLocalizedData.DllPath.SetDllFullPath {
        try
        {
            Set-DacDllPath -Path (Join-Path ([System.IO.Path]::GetTempPath()) "Microsoft.SqlServer.Dac.dll") -ErrorAction Stop
            $DllPath = Get-DacDllPath
            $Result = $true
        }
        catch
        {
            $DllPath = Get-DacDllPath
            $Result = $false
        }
        $Result | Should -Be $false
        $DllPath | Should -BeExactly $DacDllPath
    }

    It $global:TestLocalizedData.DllPath.SetDllFullPath {
        try
        {
            New-Item -Path $NotDacDllPath -ItemType File -Force | Out-Null
            Set-DacDllPath -Path $NotDacDllPath -ErrorAction Stop
            $DllPath = Get-DacDllPath
            $Result = $true
        }
        catch
        {
            $DllPath = Get-DacDllPath
            $Result = $false
        }
        $Result | Should -Be $false
        $DllPath | Should -BeExactly $DacDllPath
    }

    It $global:TestLocalizedData.DllPath.SetDllDirectory {
        try
        {
            Set-DacDllPath -Path (Split-Path $DacDllPath -Parent)
            $DllPath = Get-DacDllPath
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $DllPath | Should -BeExactly $DacDllPath
    }

    It $global:TestLocalizedData.DllPath.SetDllDirectory {
        try
        {
            Set-DacDllPath -Path ([System.IO.Path]::GetTempPath()) -ErrorAction Stop
            $DllPath = Get-DacDllPath
            $Result = $true
        }
        catch
        {
            $DllPath = Get-DacDllPath
            $Result = $false
        }
        $Result | Should -Be $false
        $DllPath | Should -BeExactly $DacDllPath
    }
}