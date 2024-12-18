#!/usr/bin/bash

source ../functions.sh

PACKAGES_APT=(
	nginx
	default-jre
)

update_apt
install_apt ${PACKAGES_APT[@]}

install_bin_from_zip "Ubooquity" "ubooquity.zip" "Ubooquity.jar" "http://vaemendis.net/ubooquity/service/download.php"
