$exedir = split-path -parent $MyInvocation.MyCommand.Definition
cd $exedir

Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "PFX (*.PFX)| *.PFX"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}
#Powershell to use open SSL to convert a pfx to pem 

#get cert path, can fill out manually 
Write-output "Please Browse to PFX file" 
$cert = Get-FileName "$exedir"

Write-output "Please enter password for you PFX" 
$pfxpass = read-host

#system setup stuff
$date = Get-date -Format "yyyMMdd"
$certDirf = Get-item "$cert" | select basename  #directory for storing output files "certificate name without .pfx"
$string = [io.path]::GetFileNameWithoutExtension($cert)
$string2 = $string.Substring(0)
$certDir = $string2
$opssl = ".\openssl.exe"
Write-output "$certDir"

$opssltest = If (Test-Path $exedir\openssl.exe){  Write-host "found OpenSSL.exe"  } Else {  write-host "couldn't find openSSL.exe"  } 
Invoke-Command -scriptblock { $opssltest }

Function Get-Key {
if (!(test-path $certdir-$date)){mkdir $certdir-$date -force}
cd $exedir
Invoke-Expression "$opssl pkcs12 -in '$cert' -passin pass:$pfxpass -nocerts -out '$certdir-$date\$certdir-encrypted-key.pem' -nodes"
Write-host "encrypted key written"
sleep 1
Invoke-Expression "$opssl rsa -in '$certdir-$date\$certdir-encrypted-key.pem' -out '$certdir-$date\$certdir-key.pem'"
Write-host "Key Un-encrypted"
Menu
}

Function Get-Cert {
if (!(test-path $certdir-$date)){mkdir $certdir-$date -force}
cd $exedir
Invoke-Expression "$opssl pkcs12 -in '$cert' -passin pass:$pfxpass -nokeys -clcerts -out '$certdir-$date\$certdir-Cert.pem'"
Write-host "Cert exported"
Menu
}

Function Get-CACert {
if (!(test-path $certdir-$date)){mkdir $certdir-$date -force}
cd $exedir
Invoke-Expression "$opssl pkcs12 -in '$cert' -passin pass:$pfxpass -nokeys -cacerts -out '$certdir-$date\$certdir-CA-Cert.pem'"
Write-host "CA-Cert exported"
Menu
}



Function Menu{
[int]$MenuChoice = 0
while ( $MenuChoice -lt 1 -or $MenuChoice -gt 4 ){
Write-host "All exports are in PEM format except for privet keys"
Write-host "1. Export privet key"
Write-host "2. Export Certificate"
Write-host "3. Export Ca Certificaet"
write-host "4. Exit"
[Int]$MenuChoice = read-host "Please enter an option 1 to 4..." 
    }
Switch( $MenuChoice ){
  1{Get-Key}
  2{Get-Cert}
  3{Get-CACert}
  4{Exit}
    }
}
Menu

<# 
Take the file you exported (e.g. certname.pfx) and copy it to a system where you have OpenSSL installed. Note: the *.pfx file is in PKCS#12 format and includes both the certificate and the private key.
Run the following command to export the private key: openssl pkcs12 -in certname.pfx -nocerts -out key.pem -nodes
Run the following command to export the certificate: openssl pkcs12 -in certname.pfx -nokeys -out cert.pem
Run the following command to remove the passphrase from the private key: openssl rsa -in key.pem -out server.key
#>