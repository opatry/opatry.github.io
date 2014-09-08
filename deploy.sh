#!/usr/bin/env sh

set -e

BASE_DIR=$(cd $(dirname "$0") && pwd)

. bash-utils/colors.sh
. bash-utils/status.sh

ftp_host="ftp.cluster015.ovh.net"
remote_dir="/www"
ftp_user="opatry"
local_dir=$BASE_DIR/output

cd $BASE_DIR

bundle install

bundle exec nanoc compile

bundle exec nanoc check \
  ilinks \
  elinks \
  css \
  stale

# until `nanoc deploy` through ftp (or even better lftp) is available, do it by hand

# user specific parameters must be set in calling environment to allow several ftp users to use it and to avoid password storage
if test -z "${ftp_user}"; then
  error_msg "'${CYAN}ftp_user${RESET}' must be set"
  exit 1;
fi

if test -z "${ftp_password}"; then
  echolor "!! ${YELLOW}Please give the ftp password${RESET} !!"
  stty -echo
  read ftp_password
  stty echo
fi

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

cd -
