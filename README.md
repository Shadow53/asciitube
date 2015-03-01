# asciitube
Collection of scripts to watch youtube videos in a terminal or tty

# Dependencies
I am working on dependency recognition and installation for the main distributions as well as some others, all taken care of inside the script itself. As it is, here they are:
- [youtube-dl](http://rg3.github.io/youtube-dl/) - manual installation implemented
- [mplayer](http://www.mplayer.org/)
- [aalib](http://aa-project.sourceforge.net/aalib/)
- [libcaca](http://caca.zoy.org/wiki/libcaca)
- [Node.js](http://nodejs.org/)
- [ytsearch](https://www.npmjs.com/package/ytsearch) for Node.js

# To-do
- Detect resolution for output
- Fix dependency installation - syntax errors
- Streaming rather than downloading (if even possible)
- Windows/Mac OS X versions
	- I don't own a Mac so i can't do that myself. I will eventually be able to work on Windows though.

# Systems with dependency-check compatibility
*NOTE: All distributions are compatible with this script, but users of these systems can have the libraries and programs they need installed by the script instead of manually.*
- Ubuntu
- Debian jessie/sid (certain packages are not available in wheezy or squeeze)
- Fedora
- openSUSE
- Arch
- Frugalware

# Usage asciitube.sh [options] 
Options:
-c              Use libcaca for colorized ASCII output
-b              Use aalib for black and white ASCII output
-s <query>      Search query (surround in quotes if there is a space)
    
