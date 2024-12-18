#!/usr/bin/bash

source ../functions.sh

bw_login
bw_unlock

bw get note id_ergaleio > $HOME/.ssh/id_ergaleio
bw get note id_ergaleio.pub > $HOME/.ssh/id_ergaleio.pub
bw get note id_gh_1npo > $HOME/.ssh/id_gh_1npo
bw get note id_gh_1npo.pub > $HOME/.ssh/id_gh_1npo.pub
bw get note id_gh_oswaldisaacs > $HOME/.ssh/id_gh_oswaldisaacs
bw get note id_gh_oswaldisaacs.pub > $HOME/.ssh/id_gh_oswaldisaacs.pub
