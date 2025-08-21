#!/bin/bash
#Setup and installation script for Jules development environment

wget https://hashcat.net/files/hashcat-5.1.0.7z
sudo apt-get install p7zip -y
sudo p7zip -d hashcat-5.1.0.7z
cd hashcat-5.1.0
sudo cp hashcat64.bin /usr/bin/
sudo ln -s /usr/bin/hashcat64.bin /usr/bin/hashcat	
sudo cp -Rv OpenCL/ /usr/bin/
sudo cp hashcat.hcstat2 /usr/bin/

sudo cp hashcat.hctune /usr/bin/
