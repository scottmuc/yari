[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory=$true)]
    [string] $Version,
    [Parameter(Position=1,Mandatory=$false)]
    [switch] $MachineScope
)

$ErrorActionPreference = "Stop"

$registry = @{
    "1.8.7" = @{
        "url" = "http://rubyforge.org/frs/download.php/74296/ruby-1.8.7-p334-i386-mingw32.7z";
        "gem_path" = "lib\ruby\gems\1.8\bin"
    };
    "1.9.2" = @{
        "url" = "http://rubyforge.org/frs/download.php/75128/ruby-1.9.2-p290-i386-mingw32.7z";
        "gem_path" = "lib\ruby\gems\1.9.1\bin"
    };
    "devkit" = @{
        "url" = "http://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe"
    }
}

function Download-File {
    param($url, $localFile = (Join-Path $pwd.Path $url.SubString($url.LastIndexOf('/') + 1)))
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $localFile)
}

function Install-Devkit {
    param($ruby_dir, $devkit_dir) 
    if (Test-Path "$ruby_dir\lib\ruby\site_ruby\devkit.rb") { return }
    $env:PATH = "$ruby_dir\bin"
    & ruby $devkit_dir\dk.rb init
    "- $ruby_dir".Replace("\", "/") | Out-File config.yml -NoClobber -Append -Encoding ASCII
    & ruby $devkit_dir\dk.rb install
    del config.yml
}

function Install-Ruby {
    param($version)
    $ruby_url = $registry."$version".url 
    $devkit_url = $registry.devkit.url 
    $ruby_filename = $ruby_url.SubString($ruby_url.LastIndexOf('/') + 1)
    $devkit_filename = $devkit_url.SubString($devkit_url.LastIndexOf('/') + 1)

    if (-not (Test-Path .\$ruby_filename)) { Download-File $ruby_url }
    if (-not (Test-Path .\$devkit_filename)) { Download-File $devkit_url }

    $ruby_archive = (Get-ChildItem $ruby_filename)
    $ruby_dir = "$pwd\$($ruby_archive.BaseName)"
    $devkit_dir = "$pwd\devkit"

    if (-not (Test-Path $ruby_dir)) { & .\7z.exe x -y $ruby_filename | Out-Null }
    if (-not (Test-Path $devkit_dir)) { & .\7z.exe x -y -odevkit $devkit_filename | Out-Null }

    $gem_bin_dir = "$ruby_dir\$($registry.`"$version`".gem_path)"
    Install-Devkit $ruby_dir $devkit_dir | Out-Host
    return "$ruby_dir\bin;$gem_bin_dir"
}

function Create-TempEnvScript {
    param( [string] $path_augmentation, [switch] $machine_scope)
    $batch_script = "set PATH=$path_augmentation;%PATH%"
    if ($machine_scope) { $batch_script += "`nsetx PATH `"$path_augmentation;%PATH%`" /M`n" }
    $batch_script | Out-File yari.tmp.cmd -Encoding ASCII
}

$path_aug = Install-Ruby $version
Create-TempEnvScript $path_aug -machine_scope:$machineScope 
