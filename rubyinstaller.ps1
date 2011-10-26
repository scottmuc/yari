function Download-File {
    param($url, $localFile = (Join-Path $pwd.Path $url.SubString($url.LastIndexOf('/'))) )
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $localFile)
}

function Install-Devkit($ruby_dir, $devkit_dir) {
    if (Test-Path "$ruby_dir\lib\ruby\site_ruby\devkit.rb") { return }
    $env:PATH = "$ruby_dir\bin"
    Install-Devkit $ruby_dir $devkit_dir 
    & ruby $devkit_dir\dk.rb init | Out-Null 
    "- $ruby_dir".Replace("\", "/") | Out-File config.yml -NoClobber -Append -Encoding ASCII
    & ruby $devkit_dir\dk.rb install | Out-Null
    del config.yml
}

function Install-Ruby {
    $ruby_url = "http://rubyforge.org/frs/download.php/75128/ruby-1.9.2-p290-i386-mingw32.7z"
    $devkit_url = "http://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe"
    $ruby_filename = $ruby_url.SubString($ruby_url.LastIndexOf('/') + 1)
    $devkit_filename = $devkit_url.SubString($devkit_url.LastIndexOf('/') + 1)
    $ruby_dir = "$pwd\ruby-1.9.2-p290-i386-mingw32"
    $devkit_dir = "$pwd\devkit"

    if (-not (Test-Path .\$ruby_filename)) { Download-File $ruby_url }
    if (-not (Test-Path .\$devkit_filename)) { Download-File $devkit_url }
    if (-not (Test-Path $ruby_dir)) { & .\7z.exe x -y $ruby_filename | Out-Null }
    if (-not (Test-Path $devkit_dir)) { & .\7z.exe x -y -odevkit $devkit_filename | Out-Null }

    Install-Devkit $ruby_dir $devkit_dir
    Write-Host "$ruby_dir\bin;$ruby_dir\lib\ruby\gems\1.9.1\bin"
}

Install-Ruby
