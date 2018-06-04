OVERVIEW
    Simple powershell Script that uses openssl for windows to convert pfx bundles into PEM certificate and key files. 

PREREQUISITES
    Open SSL for windows, Source: https://opendec.wordpress.com/
    Tested with verison: 1.0.2g win64 on wind 7/8.1/10

    Only tested with powershell 4.0+

Use
    1. Export PFX from server
    2. clone powershell script to same directory as openssl
    3. Run powershell script
    4. browse to PFX file
    5. Enter PFX password
    6. Select menu option to complete one of the following. 
     - export CA cert
     - export public key
     - export Privet key (auto decypt to "RSA PRIVATE KEY")
     - Exit script

Things to do, 
- Finish readme
- Update to allow for paramiters in command line
- Clean up openssl.exe tested
- Add more options
- Add more comments




