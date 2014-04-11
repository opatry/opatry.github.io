---
title: Automated web site deployment (git+ftp inside)
kind: note
created_at: 2014-04-11 14:08:42 +0200
---

There are plenty of ways to automate the deployment of a website (GitHub pages with Jekyll, Maven, Git commit hooks, …). Unfortunately some configurations (most of the time cheap ones) doesn't allow easy source control interaction on server side (mutualized hosting).

My current solution is to combine a local Jenkins, a remote Git branch and `lftp`.

My Git source control contains two main branches `master` and `prod`. The first one (default) is used for common development tasks and the other is only modified when an update of the Web site on the Internet must be done.

My Jenkins job only polls on the `prod` branch and invokes the following script to synchronize the Web site state and the current sources.

``` bash
#!/bin/bash

# retrieve the absolute path of this script in a portable manner
BASE_DIR=$(cd $(dirname "$0") && pwd)

ftp_host="ftp.your.conf.com"
remote_dir="/ftp/remote/directory"
local_dir=$BASE_DIR; # we consider here that the web site sources are sibling of this script

# user specific parameters must be set in calling environment to allow several ftp users to use it and to avoid password storage
if [[ -z "${ftp_user}" ]]; then
  echo "'ftp_user' must be set"
  exit 1;
fi

if [[ -z "${ftp_password}" ]]; then
  echo "'ftp_password' must be set"
  exit 1;
fi

# if you use composer, ensures the Jenkins workspace contains up to date dependencies
pushd $BASE_DIR
composer update || exit $?
popd

# use lftp to synchronize the source with the FTP server for only modified files.
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
       --exclude-glob composer.* \
       --exclude-glob *.sh" || exit $?

```

The important parts are the `lftp` command itself and its special commands `--only-newer` combined with `--ignore-time`. The `--reverse` switch tells `lftp` to upload files instead of downloading them.

By default, the upload doesn't update file timestamp so the `--only-newer` doesn't work as expected, you'll have to tell `lftp` to ignore time to get the expected behavior.

Doing so will update only modified files (comparison by size, so not 100% sure…) on remote FTP server.

There are several drawbacks compared to other (better?) solutions, no rollback possibility, no atomicity, file to update criterion not safe etc. But for cheap configurations it helps a lot to automate the process of deploying a website. The only manual action is to push the changes you want on the remote prod branch.

_Note: This post has been extracted from its [CoderWall original version](https://coderwall.com/p/zqs1nw)._
