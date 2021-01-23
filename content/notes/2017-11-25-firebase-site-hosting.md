---
title: Firebase site hosting
kind: note
created_at: 2017-11-25 20:51:00 +0200
---

---

<%= e('⚠️') %> This “how-to” deserves some love <%= e('❤️') %>. Should provide alternative CI setup for the new player in the market,
[GitHub Actions](https://github.com/features/actions) workflows.
{: .disclaimer }

Also, since [v7.1](https://github.com/firebase/firebase-tools/releases/tag/v7.1.0), `firebase` hosting requires a service account to allow CI deployment.

- [FirebaseExtended/action-hosting-deploy/main/docs/service-account.md](https://github.com/FirebaseExtended/action-hosting-deploy/blob/main/docs/service-account.md)
- [support/guides/service-accounts](https://firebase.google.com/support/guides/service-accounts)
- [stackoverflow/login-to-firebase-using-gcloud-service-account](https://stackoverflow.com/questions/59053919/login-to-firebase-using-gcloud-service-account)
- [stackoverflow/firebase-tools-login-as-service-account](https://stackoverflow.com/questions/45437286/firebase-tools-login-as-service-account)

There is also a [🔥🌎 Firebase Hosting GitHub Action](https://github.com/FirebaseExtended/action-hosting-deploy) ready to use to deploy site.

(January 8, 2021)
{: .metadata}

---

I used to host this website on a cheap FTP server and <%= link_to_item('deploy it using `lftp`', '/notes/2014-04-11-automated-web-site-deployment.*') %>.
It seems now a bit archaic, I use Firebase to host it these days.
Here follows the setup to automatically deploy the website using hosted Continuous Integration services such as BitBucket or GitLab Pipelines.

## Local setup

First, you'll need to setup your local work environment by installing Firebase tools:

```bash
$ npm install -g firebase-tools
```

Then, login to your Google account using `firebase login`.

To map your local work tree to a Firebase project, execute `firebase init` and select `Hosting`. You'll be asked to choose 
or create a Firebase project.

Once done, `.firebaserc` and `firebase.json` files will be created. The former defines the Firebase project and the latter
defines some configuration for your project structure, like the directory to publish.
For a [`nanoc`](https://nanoc.ws/) website you'll use `output`:

```json
{
  "hosting": {
    "public": "output"
  }
}
```

Finally, deploy your local output online using `firebase deploy`.

## Continuous Integration setup

You can choose to deploy your site by hand using your local copy but sooner or later, you'll be better with a
continuous integration build for this purpose.

I share here the BitBucket and GitLab pipelines configurations I used for this website.

There is no big difficulty, the tedious part was the provisioning of the image used to build this site due to
its dependencies (`pygmentize` for syntax highlighting, Node JS for minifiers and Firebase…).

For any CI, you'll need to generate a token allowing automated deployment:

```bash
$ firebase login:ci

Visit this URL on any device to log in:
<some long URL to use>

Waiting for authentication...

✔  Success! Use this token to login on a CI server:

<CI token to keep as an environment variable>

Example: firebase deploy --token "$FIREBASE_TOKEN"
```

<!-- title broken after ``` ``` block, needed something (like this comment!) to fix it -->

### BitBucket

To use [BitBucket pipelines](https://bitbucket.org/product/features/pipelines), create a `bitbucket-pipelines.yml` file:

```yaml
image: ruby:2.4.0

pipelines:
  branches:
    master:
    - step:
        caches:
          - npm
          - bundler
        script:
          - curl -sL https://deb.nodesource.com/setup_8.x | bash -
          - apt-get update -qq && apt-get install -y nodejs python-pygments locales
          - echo "en_US UTF-8" > /etc/locale.gen
          - locale-gen en_US.UTF-8
          - export LANG=en_US.UTF-8
          - export LANGUAGE=en_US:en
          - export LC_ALL=en_US.UTF-8
          - npm install --prefix .npm firebase-tools
          - bundle install --path=.bundler
          - bundle exec nanoc compile
          - bundle exec nanoc check ilinks elinks css stale
          - .npm/node_modules/firebase-tools/bin/firebase deploy -m "BitBucket build#$BITBUCKET_BUILD_NUMBER" --token "$FIREBASE_TOKEN" --non-interactive

  custom:
    check:
      - step:
          caches:
            - bundler
          script:
            - curl -sL https://deb.nodesource.com/setup_8.x | bash -
            - apt-get update -qq && apt-get install -y nodejs python-pygments locales
            - echo "en_US UTF-8" > /etc/locale.gen
            - locale-gen en_US.UTF-8
            - export LANG=en_US.UTF-8
            - export LANGUAGE=en_US:en
            - export LC_ALL=en_US.UTF-8
            - bundle install --path=.bundler
            - bundle exec nanoc compile
            - bundle exec nanoc check ilinks elinks css stale

definitions:
  caches:
    bundler: .bundler
    npm: .npm
```

As you might have noticed, I used a `FIREBASE_TOKEN` environment variable, go to `Settings > Pipelines / Environment Variables`.
Add a new _secured_ environment variable `FIREBASE_TOKEN` with the value returned by `firebase login:ci`.

In this setup, I publish only on `master` branch but allow build from any other branch to validate it without deploying.

### GitLab

The [GitLab pipeline](https://docs.gitlab.com/ee/ci/pipelines.html) setup is similar, create a `.gitlab-ci.yml` file:

```yaml
image: "ruby:2.4"

cache:
  paths:
  - .npm
  - .bundler

before_script:
  - curl -sL https://deb.nodesource.com/setup_8.x | bash -
  - apt-get update -qq && apt-get install -y nodejs python-pygments locales
  - echo "en_US UTF-8" > /etc/locale.gen
  - locale-gen en_US.UTF-8
  - export LANG=en_US.UTF-8
  - export LANGUAGE=en_US:en
  - export LC_ALL=en_US.UTF-8
  - gem install bundler --no-ri --no-rdoc
  - bundle install --path=.bundler --jobs $(nproc)

compile:
  stage: build
  script:
    - bundle exec nanoc compile
  artifacts:
    paths:
    - output/

check:
  stage: test
  script:
    - bundle exec nanoc check ilinks elinks css stale

deploy:
  stage: deploy
  script:
    - npm install --prefix .npm firebase-tools
    - .npm/node_modules/firebase-tools/bin/firebase deploy -m "GitLab Pipeline#$CI_PIPELINE_ID Build#$CI_BUILD_ID" --token "$FIREBASE_TOKEN" --non-interactive
  only:
    - master
```

This time, the `FIREBASE_TOKEN` variable should be created from `Settings > CI/CD > Secret Variables`.

The `deploy` Job is only available on `master` branch, this way, you can have build validation on any branch but continuous deployment only on `master`.

I had troubles with UTF-8 encoding, [needed `en_US.UTF-8` locale installation and configuration](https://gitlab.com/gitlab-org/gitlab-foss/-/issues/14983#note_4637913).

---

You can also refer to the [Firebase command line documentation](https://firebase.google.com/docs/cli/).

The initial source of this _How To_ comes from [Chris Banes](https://chris.banes.dev/jekyll-firebase/). 
Chris Banes's article provides CI setup for Circle CI.
