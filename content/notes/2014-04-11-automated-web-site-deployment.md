---
title: Automated web site deployment
kind: note
created_at: 2014-04-11 14:08:42 +0200
---

---

**⚠️** _This “how-to” is outdated. Still relevant if you want to use `lftp` but you have now much more
convenient solution like <%= link_to_item('Firebase hosting', '/notes/2017-11-25-firebase-site-hosting.*') %>._

(November 25, 2017)
{: .metadata}

---

There are plenty of ways to automate the deployment of a website (GitHub pages with Jekyll, Maven, Git commit hooks…). 
Unfortunately some configurations (cheap ones, most of the time) don't allow easy source control interaction on server side.

We can use `lftp` to deploy only modified files.

The Git source control contains two main branches `master` and `prod`. The first one (default) is used for common development tasks and the other is only modified when an update of the Web site on the Internet must be done.

The following script is used to synchronize the local and remote site states.

``` bash
#!/usr/bin/env bash

set -eu

# retrieve the absolute path of this script in a portable manner
cur_dir=$(cd "$(dirname "$0")" && pwd)

if [ $# -lt 2 ]; then
  echo "USAGE: $0 ftp_user ftp_password [ftp_host] [remote_dir]"
  exit 1
fi

ftp_user="${1}"
ftp_password="${2}"
ftp_host=${3:-"ftp.your.conf.com"}
remote_dir=${4:-"/ftp/remote/directory"}
local_dir="${cur_dir}"; # we consider here that the web site sources are sibling of this script

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
       --exclude-glob *.sh"
```

The important parts are the `lftp` command itself and its special commands `--only-newer` combined with `--ignore-time`.
The `--reverse` switch tells `lftp` to upload files instead of downloading them.

By default, the upload doesn't update file timestamp so the `--only-newer` doesn't work as expected,
you'll have to tell `lftp` to ignore time to get the expected behavior.

Doing so will update only modified files (comparison by size, so not 100% sure…) on remote FTP server.

There are several drawbacks compared to other (better?) solutions, no rollback possibility, no atomicity, file to update
criterion not safe etc. But for cheap configurations it helps a lot to automate the process of deploying a website. 
