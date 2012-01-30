$ErrorActionPreference = "Stop"

$stage    = "$($env:Temp)\yari-install"
$7zip_exe = "$stage\7z.exe"
$7zip_dll = "$stage\7z.dll"
$yari_zip = "$stage\yari.zip"
$target_path = "$($env:UserProfile)\.yari"

if ($target_path.Contains(" ")) {
    $target_path = Read-Host "Enter a target path (no spaces allowed) for the yari installation, e.g. C:\yari"
}

if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
if (Test-Path $target_path) { Remove-Item $target_path -Recurse -Force }

md $stage | Out-Null
md $target_path | Out-Null

function Download {
    param($url, $file)

    if (Test-Path $file) { Remove-Item $file | Out-Null }
    "Downloading $url" | Write-Host
    (new-object Net.WebClient).DownloadFile($url, $file)
}

Download "https://github.com/scottmuc/yari/blob/master/7z.exe?raw=true" $7zip_exe
Download "https://github.com/scottmuc/yari/blob/master/7z.dll?raw=true" $7zip_dll
Download "https://github.com/scottmuc/yari/zipball/master" $yari_zip

pushd $stage
& .\7z.exe x -y yari.zip | Out-Null
popd

$extracted_path = (Resolve-Path $stage\*-yari-*).Path + "\*"

Copy-Item $extracted_path $target_path -Recurse

$user_PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
$PATH_aug  = "$($target_path)\bin"

if ($user_PATH -eq $null) { $user_PATH = "" }

if (-not $user_PATH.Contains($PATH_aug)) {
    [Environment]::SetEnvironmentVariable("PATH", "$PATH_aug;$user_PATH", "User") 
}

"yari successfully installed to location: '$target_path' !" | write-Host -f Green
