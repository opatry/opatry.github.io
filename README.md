[![Build, test and deploy Status](https://github.com/opatry/opatry.github.io/actions/workflows/build_test_deploy.yml/badge.svg)](https://github.com/opatry/opatry.github.io/actions/workflows/build_test_deploy.yml)

# Olivier Patry

The content is, most of the time, written using [**`[M↓]`** Markdown](http://daringfireball.net/projects/markdown/) and served by [`nanoc`](http://nanoc.ws/).

This website is available at https://opatry.net using [🔥 Firebase hosting](https://firebase.google.com/products/hosting)
and https://opatry.github.io/ using [📄 GitHub Pages](https://pages.github.com/)
both thanks to [🤖 GitHub Actions](https://github.com/features/actions). 

## 🛠 Requirements & Initial setup

```bash
$ gem install bundler
$ bundle install
$ bundle exec nanoc compile
```

## Debug Ruby code 🔎 💎
<details>
<summary>See details…</summary>

Using Visual Studio Code and `ruby-debug-ide`, initial setup requires to install `binstubs` for few binaries:

```bash
$ bundle install
$ bundle binstubs bundler nanoc ruby-debug-ide
```

Then, debug launch configuration should work out of the box in VS Code (put a breakpoint (in `Rules#preprocess` for example) then press <kbd>F5</kbd>).
</details>

## JavaScript development

```bash
$ npm install && npm install --only=dev
$ ./node_modules/.bin/eslint --init
```
