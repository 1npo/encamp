function mnt-nas-media() {
	if [ $# -gt 0 ]; then
		mount_dir=$1
	else
		mount_dir="/mnt/apothiki/media/"
	fi
	sudo mount -t cifs -o rw,credentials=$HOME/.smbcredentials,uid=1000,gid=1000 //apothiki/Media $mount_dir
}

function mnt-nas-backups() {
	if [ $# -gt 0 ]; then
		mount_dir=$1
	else
		mount_dir="/mnt/apothiki/backups/"
	fi
	sudo mount -t cifs -o rw,credentials=$HOME/.smbcredentials,uid=1000,gid=1000 //apothiki/Backups $mount_dir
}

