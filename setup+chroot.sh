#backs up the default make.conf
#this puts some things in place like your make.conf, aswell as package.use

PURPLE='\u001b[36m'

# Extract stage tarball
cd /mnt/gentoo/
stage3=$(ls stage3*)
printf "found %s\n" $stage3
tar xpvf $stage3 --xattrs-include='*.*' --numeric-owner

wget https://github.com/anunna/gentooscripts/archive/master.zip
unzip /mnt/gentoo/master.zip
mkdir /mnt/gentoo/etc/portage/backup
unzip /mnt/gentoo/gentooscripts-master/gentoo/portage.zip

#mv /mnt/gentoo/etc/portage/make.conf /mnt/gentoo/etc/portage/backup/
printf "moved old make.conf to /backup/\n"
#copies our pre-made make.conf over
\cp make.conf /mnt/gentoo/etc/portage/
printf "copied new make.conf to /etc/portage/\n"

#copies specific package.use stuff over
cp -a package.use/. /mnt/gentoo/etc/portage/package.use/
printf "copied over package.use files to /etc/portage/package.use/\n"

#copies specific package stuff over (this might not be necessary)
cp linux_drivers /mnt/gentoo/etc/portage/
cp package.license /mnt/gentoo/etc/portage
cp package.accept_keywords /mnt/gentoo/etc/portage/
printf "copied over specific package stuff\n"

#gentoo ebuild repository
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp repos.conf/gentoo.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

printf "copied gentoo repository to repos.conf\n"

#copy DNS info
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
printf "copied over DNS info\n"

cp /mnt/gentoo/gentooscripts-master/post_chroot.sh /mnt/gentoo/
printf "copied post_chroot.sh to /mnt/gentoo\n"
chmod +x /mnt/gentoo/post_chroot.sh

mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev

rm -rf /portage
printf "clened up files\n"
printf "mounted all the things\n"
printf "you should now chroot into the new environment\n"
chroot /mnt/gentoo /bin/bash
printf ${PURPLE}"chroot /mnt/gentoo /bin/bash"
printf ${PURPLE}"source /etc/profile"
printf ${PURPLE}"export PS1=\"(chroot) \${PS1}\""

cd /mnt/gentoo

#below this point we have to create a seperate script to run in the chroot portion
#chroot /mnt/gentoo /bin/bash << "EOT"
#source /etc/profile
#export PS1="(chroot) ${PS1}"

chroot /mnt/gentoo ./post_chroot.sh
