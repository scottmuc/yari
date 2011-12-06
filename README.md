# Yet Another Ruby Installer: yari

yari lets you install and switch between multiple versions of Ruby. Somewhat
inspired by [rvm](http://beginrescueend.com/) and [rbenv](https://github.com/sstephenson/rbenv) 
for unix like operating systems.

### yari does...

* Install ruby versions defined in the hard-coded registry in the script
* Download and configures the DevKit so you can install gems with native extensions
* Let you change ruby versions for your console session 
* Set the ruby version for the machine

## How It Works

yari will download and configure ruby to wherever you clone the yari. It will then modify
your PATH so that the ruby version chosen will be used. 

## Installation

1. Check out somewhere (I persoanlly put in in %USERPROFILE%\\.yari)

        > cd %USERPROFILE%
        > git clone git://github.com/scottmuc/yari.git .yari

2. Add this location to your PATH

        > setx PATH %USERPROFILE%\.yari\bin

   **Note**: if you already have something in your USER PATH environment variable
   this will overwrite it. I'm working on fixing this.

3. Restart a new shell

### Experimental Installation

Copy and paste the following in a Powershell Prompt

        PS > (new-object Net.Webclient).DownloadString("https://github.com/scottmuc/yari/raw/master/installer.ps1") | iex

## Usage

1. Setup your shell session to use ruby 1.9.2

        > yari 1.9.2
        >
        > ruby -v
        ruby 1.9.2p290 (2011-07-09) [i386-mingw32]

