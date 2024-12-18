#!/usr/bin/bash
#
# Resources
# ---------
# * https://unix.stackexchange.com/questions/733425/creating-debug-of-a-bash-script-menu
#

VERSION="1.0.0"
PACKAGE_GROUPS=(
	base 1 on
	dev 2 off
	desktop 3 off
	server 4 off
)

function dialog_menu() {
	type="$1"
	shift
	title="$1"
	shift
	options=("$@")

	case $type in
		"menu") echo $(
			dialog \
				--stdout \
				--backtitle "encamp v$VERSION" \
				--title "$title" \
				--menu "" 0 0 0 "${options[@]}"
			)
		;;
		
		"checklist") echo $(
			dialog \
				--stdout \
				--backtitle "encamp v$VERSION" \
				--title "$title" \
				--checklist "" 0 0 0 "${options[@]}"
			)
		;;
	esac	
}

INSTALL_PACKAGES=$(dialog_menu "checklist" "Choose Package Groups to Install" ${SYSTEMS[@]})

case $SYSTEM in
	1)	PACKAGES=$(dialog_menu "checklist" "Available Package Installers" ${PACKAGES_DEBIAN[@]});
		echo "Getting packages: $PACKAGES" ;;
	2)	echo ;;
esac