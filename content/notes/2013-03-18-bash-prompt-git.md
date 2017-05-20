---
title: Bash Prompt with Git Support
kind: note
created_at: 2013-03-18 12:00:00 +0200
---
# Display current git branch in bash prompt
Using `git branch` we can retrieve the current git branch if any.

You can use the following `PS1` definition (by editing your `~/.bashrc` file for instance):

``` bash
export PS1='\n\[\033[0;36m\w/\033[m \033[0;33m`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\033[m\]\n\033[0;35m⌘\033[m  '
```

Displays something like that:

<div style="font-family: monospace;">
<pre><code><span style="color: #06989A;">~/work/opatry.net/opatry.github.com/</span> <span style="color: #C4A000;">(master)</span> 
<span style="color: #75507B;">&#8984;</span> <span title="Your cursor" style="cursor: help; text-decoration: blink;">&#166;</span></code></pre>
</div>

[via](http://markdotto.com/2013/01/13/improved-terminal-hotness/)

Another [demonstration which add an extra `*`](http://nathanhoad.net/git-bash-tab-completions-and-a-cool-prompt) when the repository is dirty.

Here is my current one:
	
``` bash
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}

export PS1='\n\[\033[0;36m\w/\033[m \033[0;33m$(parse_git_branch)\033[m\]\n\033[0;35m\$\033[m '
```

<div style="font-family: monospace;">
<pre><code><span style="color: #06989A;">~/work/opatry.net/opatry.github.com/</span> <span style="color: #C4A000;">(master)*</span> 
<span style="color: #75507B;">$</span> <span title="Your cursor" style="cursor: help; text-decoration: blink;">&#166;</span></code></pre>
</div>