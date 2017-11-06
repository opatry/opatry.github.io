#!/usr/bin/env bash

set -eu

cur_dir=$(cd "$(dirname "$0")" && pwd)

ftp_host="ftp.cluster015.ovh.net"
remote_dir="/www"
ftp_user=${1:-"opatry"}
local_dir="${cur_dir}/output"

cd "$cur_dir"

(
  bundle install

  bundle exec nanoc compile

  # elinks disabled because of linked in link wrongly marked as invalid
  bundle exec nanoc check \
    ilinks \
    css \
    stale
)

# until `nanoc deploy` through ftp (or even better lftp) is available, do it by hand

echo "Please give the ftp password"
stty -echo
read -r ftp_password
stty echo

# use lftp to synchronize the source with the FTP server for only modified files.
# see https://coderwall.com/p/zqs1nw for further details
lftp -c "
#debug;
open ftp://${ftp_user}:${ftp_password}@${ftp_host}
lcd ${local_dir};
cd ${remote_dir};
mirror --only-newer \
       --ignore-time \
       --reverse \
       --parallel=5 \
       --verbose \
       --exclude .git/ \
       --exclude .gitignore \
       --exclude-glob *.sh"
