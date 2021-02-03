# mLauncher



Quickly Join your favorite servers.

define your favorite servers in the config . and quickly  direct connect to them
optionally supports both experimental and community servers, with the option to delete all mods on startup.

get the latest release from the [releases](https://github.com/SvalTek/mLauncher/releases) section or build yourself using [luvi](https://github.com/luvit/luvi)



just place the `mLauncher.exe` and `settings.json` somwhere together, and create a desktop shortcut.

edit `settings.json` to define program settings and favorite servers.

  NOTE: the comments in settings.json  are there to show how things work... mLauncher will fail to run unless you remove them all.
  
  NOTE: you can create a shortcut to launch a specific server from your settings. 
  - create anouther shortcut to mLauncher.exe
  - then edit the shortcut and add params `[index] [purge]` after the path.
      replacing `[index]` with the server index and `[purge]` with true or nothing to purge mods when starting
        
     EG: `"C:\Tools\mLauncher\mLauncher.exe" 1 true` to launch server 1 and purge the Mods folder
