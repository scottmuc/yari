Yet Another Ruby Installer
==========================

This script does the follow:

* downloads ruby and the devkit
* unzips the .7z and .exe in the current directory
* sets up the devkit in your ruby base
* sets your environment variables (session or machine level)

Usage
-----

    Sets up a ruby environment for you
    
    rubyenv.bat [version] [-MachineScope]
    
      version          1.8.7, 1.9.2
      -MachineScope    permanently sets your machines PATH otherwise it only
                       sets it for the current session

