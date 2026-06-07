function mount-smb-share() {
	case $# in 
		'all')
			mount-smb('//apothiki/Backup', '/mnt/net/apothiki/backup')
			mount-smb('//apothiki/Media', '/mnt/net/apothiki/media')
			mount-smb('//diatom/nick', '/mnt/net/diatom/nick')
			mount-smb('//globule/nick', '/mnt/net/globule/nick')
			;;
		'apothik-backup')
			mount-smb('//apothiki/Backup', '/mnt/net/apothiki/backup')
			;;
		'apothiki-media')
			mount-smb('//apothiki/Media', '/mnt/net/apothiki/media')
			;;
		'diatom')
			mount-smb('//diatom/nick', '/mnt/net/diatom/nick')
			;;
		'globule')
			mount-smb('//globule/nick/', '/mnt/net/globule/nick')	
			;;
	esac
}

function mount-smb() {
	sudo mount -t cifs -o rw,credentials=$HOME/.smbcredentials,uid=1000,gid=1000 $1 $2
}

function csv() {
	eval $(column -s, -t < $1 | less -#2 -N -S')
}
