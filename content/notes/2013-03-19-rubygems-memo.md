---
title: Rubygems Memo
kind: note
created_at: 2013-03-19 12:00:00 +0200
---
# Rubygems documentation build failures
At least on Ubuntu 12.04 and 12.10, I was unable to successfully install the [Jekyll](http://jekyllrb.com/) gem (get the same issues with some other gems) due
to documentation build error.
A solution I found was to disable the documentation by using extra argument to the `gem install` command: `--no-ri --no-rdoc`.
You can add these options permanently by editing your `~/.gemrc` file:

``` ruby
gem: --no-ri --no-rdoc
```

[via](http://nathanhoad.net/how-to-stop-rubygems-automatically-installing-documentation)