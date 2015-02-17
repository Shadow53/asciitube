# asciitube
Wrapper for youtube-dl and mplayer to watch youtube videos in a terminal or tty

# Dependencies
I am working on dependency recognition and installation for the main distributions as well as some others, all taken care of inside the script itself. As it is, here they are:
- [youtube-dl](http://rg3.github.io/youtube-dl/) - manual installation implemented
- [mplayer](http://www.mplayer.org/)
- [aalib](http://aa-project.sourceforge.net/aalib/)
- [libcaca](http://caca.zoy.org/wiki/libcaca)
- [Node.js](http://nodejs.org/)
- [ytsearch](https://www.npmjs.com/package/ytsearch) for Node.js

# To-do
- Fix aalib detection, make detection in general better
- Detect resolution for output
- Detect architecture and distribution
	- When done, next step is to install dependencies in each system
- Find a way to make it accessible to all users on the machine
- Streaming rather than downloading (if even possible)
- Windows/Mac OS X versions
	- I don't own a Mac so i can't do that myself. I will eventually be able to work on Windows though.

# Systems with dependency-check compatibility
*NOTE: All systems are compatible with this script. Users of these systems can have the libraries and programs they need installed by the script instead of manually.*
- Ubuntu
- Debian jessie/sid (certain packages are not available in wheezy or squeeze)
- Fedora
- openSUSE
- Arch
- Frugalware
