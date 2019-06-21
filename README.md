# RAK2013-Cellular-PiHat
Install script for Raspberry 


Install git:

sudo apt install git

Clone this git:

git clone https://github.com/tvelev/RAK2013-Cellular-PiHat.git

Open the folder:

cd RAK2013-Cellular-PiHat

Run the installer:

sudo ./install.sh

Insert the APN name when prompted.

After installation, reboot.

If everything is ok, after reboot you will see the blue and green led on pihat are on.
Is they are on , use “minicom -D /dev/ttyAMA0 -b 115200”. In minicom console type “AT” and it should return “OK”
PS: to exit from minicom: press enter, ctrl+a, q and enter again.
