[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory=$true)]
    [string] $Version,
    [Parameter(Position=1,Mandatory=$false)]
    [switch] $InstallMachine
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ErrorActionPreference = "Stop"

$registry = @{
    "1.8.7" = @{
        "url" = "http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.8.7-p374-i386-mingw32.7z";
        "gem_path" = "lib\ruby\gems\1.8\bin";
        "devkit" = "devkit4.5.2"
    };
    # Since i did not find the 1.9.2 download link, i remove it's support.
    #"1.9.2" = @{
    #    "url" = "http://rubyforge.org/frs/download.php/75128/ruby-1.9.2-p290-i386-mingw32.7z";
    #    "gem_path" = "lib\ruby\gems\1.9.1\bin"
    #};
    "1.9.3" = @{
        "url" = "http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.9.3-p551-i386-mingw32.7z";
        "gem_path" = "lib\ruby\gems\1.9.1\bin";
        "devkit" = "devkit4.5.2"
    };
    "2.0.0" = @{
        "url" = "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.0.0-p645-i386-mingw32.7z";
        "gem_path" = "lib\ruby\gems\2.0.0\bin";
        "devkit" = "devkit4.7.2"
    };
    "2.2.2" = @{
        "url" = "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.2-i386-mingw32.7z";
        "gem_path" = "lib\ruby\gems\2.2.0\bin";
        "devkit" = "devkit4.7.2"
    };
    "devkit4.5.2" = @{
        "url" = "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe"
    }
    "devkit4.7.2" = @{
        "url" = "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"
    }
}

function Download-File {
    param($url, $localFile)

    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url, $localFile)
}

function Install-Devkit {
    param($ruby_dir, $devkit_dir) 

    if (Test-Path "$ruby_dir\lib\ruby\site_ruby\devkit.rb") { return }
    & $ruby_dir\bin\ruby $devkit_dir\dk.rb init
    "- $ruby_dir".Replace("\", "/") | Out-File config.yml -NoClobber -Append -Encoding ASCII
    & $ruby_dir\bin\ruby $devkit_dir\dk.rb install
    del config.yml
}

function Install-Ruby {
    param($version)
    $ruby_url = $registry."$version".url 
    $devkit = $registry."$version".devkit
    $devkit_url = $registry."$devkit".url 
    $ruby_filename = $ruby_url.SubString($ruby_url.LastIndexOf('/') + 1)
    $devkit_filename = $devkit_url.SubString($devkit_url.LastIndexOf('/') + 1)

    if (-not (Test-Path $here\$ruby_filename)) { Download-File $ruby_url $here\$ruby_filename }
    if (-not (Test-Path $here\$devkit_filename)) { Download-File $devkit_url $here\$devkit_filename }

    $ruby_archive = (Get-ChildItem $here\$ruby_filename)
    $ruby_dir = "$here\$($ruby_archive.BaseName)"
    $devkit_dir = "$here\$devkit"

    pushd $here
    if (-not (Test-Path $ruby_dir)) { & .\7z.exe x -y $ruby_filename | Out-Null }
    if (-not (Test-Path $devkit_dir)) { & .\7z.exe x -y -o"$devkit" $devkit_filename | Out-Null }
    popd

    $gem_bin_dir = "$ruby_dir\$($registry.`"$version`".gem_path)"
    Install-Devkit $ruby_dir $devkit_dir | Out-Host
    return "$ruby_dir\bin"
}

function Create-TempEnvScript {
    param( [string] $path_augmentation, [switch] $machine_scope)

    if ($machine_scope) {
        [Environment]::SetEnvironmentVariable("PATH", "$path_augmentation;$($env:Path)", "Machine") 
    }
    $env:Path = "$path_augmentation;$($env:Path)"
    "set PATH=$path_augmentation;%PATH%" | Out-File $here\yari.tmp.cmd -Encoding ASCII
}

$path_aug = Install-Ruby $version
Create-TempEnvScript $path_aug -machine_scope:$InstallMachine 

"Ruby and Devkit installed successfully! Located at: '$here'" | write-Host -f Green
