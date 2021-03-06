#!/data/data/com.termux/files/usr/bin/bash

# input validator and help
apt update && apt upgrade -y
# Install requirements
apt install proot -y
apt install figlet
T='\033[0;32m'

figlet Fedora-26

case "$1" in
	f26_arm)
	    DOCKERIMAGE=http://download.fedoraproject.org/pub/fedora/linux/releases/26/Docker/armhfp/images/Fedora-Docker-Base-26-1.5.armhfp.tar.xz
	    ;;
	f26_arm64)
	    DOCKERIMAGE=http://dl.fedoraproject.org/pub/fedora-secondary/releases/26/Docker/aarch64/images/Fedora-Docker-Base-26-1.5.aarch64.tar.xz
	    ;;
	f26beta_arm)
	    DOCKERIMAGE=http://download.fedoraproject.org/pub/fedora/linux/releases/test/26_Beta/Docker/armhfp/images/Fedora-Docker-Base-26_Beta-1.4.armhfp.tar.xz
	    ;;
	f26beta_arm64)
	    DOCKERIMAGE=http://dl.fedoraproject.org/pub/fedora-secondary/releases/test/26_Beta/Docker/aarch64/images/Fedora-Docker-Base-26_Beta-1.4.aarch64.tar.xz
	    ;;
	uninstall)
	    rm -rf ~/fedora
	    exit 0
            ;;
	*)
	    echo $"Usage: $0 {f26_arm|f26_arm64|f26beta_arm|f26beta_arm64|uninstall}"
	    exit 2
esac


# get the docker image

mkdir ~/fedora
cd ~/fedora
/data/data/com.termux/files/usr/bin/wget $DOCKERIMAGE -O fedora.tar.xz

# extract the Docker image

/data/data/com.termux/files/usr/bin/tar xvf fedora.tar.xz --strip-components=1 --exclude json --exclude VERSION

# extract the rootfs

/data/data/com.termux/files/usr/bin/tar xpf layer.tar

# cleanup

chmod +w .
rm layer.tar
rm fedora.tar.xz

# fix DNS

echo "nameserver 8.8.8.8" > ~/fedora/etc/resolv.conf

# make a shortcut

cat > /data/data/com.termux/files/usr/bin/startfedora <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
proot --link2symlink -0 -r ~/fedora -b /dev/ -b /sys/ -b /proc/ -b $HOME /bin/env -i HOME=/root TERM="$TERM" PS1='[termux@fedora \W]\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
EOM

chmod +x /data/data/com.termux/files/usr/bin/startfedora


figlet  Finish

echo "${T} ████████╗ ██████╗██╗  ██╗███████╗██╗      ██████╗ ";
echo "${T} ╚══██╔══╝██╔════╝██║  ██║██╔════╝██║     ██╔═══██╗";
echo "${T}    ██║   ██║     ███████║█████╗  ██║     ██║   ██║";
echo "${T}    ██║   ██║     ██╔══██║██╔══╝  ██║     ██║   ██║";
echo "${T}    ██║   ╚██████╗██║  ██║███████╗███████╗╚██████╔╝";
echo "${T}    ╚═╝    ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ";

echo "All done! Start Fedora with 'startfedora'. Gets update with regular 'dnf update'. "
