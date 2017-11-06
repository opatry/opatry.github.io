---
title: BitBucket Pipelines Android Signing Config
kind: note
created_at: 2017-10-07 21:32:08 +0200
---

Building Android release APK can be a bit tedious when it comes to signing it.
Storing (and sharing to a restricted audience) the signing configuration, should
be done carefully especially on Open Source projects.

Using Git submodule, we can isolate sensitive information from public and only
allow access to Continuous Integration users and repository administrators.

First create a new repository (`secret`) with restricted access.

Add sensitive information in it.

`playstore.properties`:

``` properties
storeFile=myapp.keystore
keyAlias=myapp_android
storePassword=SENSITIVE_PASSWORD
keyPassword=SENSITIVE_PASSWORD2
```

Add your `myapp.keystore` near the `playstore.properties` file.

Add it to your application as a submodule.

``` bash
$ git submodule add <url> build/secret
```

Configure the application signing configuration in Gradle:

`app/build.gradle`

``` groovy
apply plugin: 'com.android.application'

def signingPropertiesFile = file('../../build/secret/playstore.properties')
def keystoreProperties = new Properties()
if (signingPropertiesFile && signingPropertiesFile.isFile()) {
    keystoreProperties.load(new FileInputStream(signingPropertiesFile))
}

android {

    signingConfigs {
        debug {
            // "public" development keystore file shared between developers
            storeFile file('../myapp_dev.keystore')
            storePassword 'devapp'
            keyAlias 'myapp_android_dev'
            keyPassword 'devapp'
        }
        release {
            storeFile = keystoreProperties['storeFile']
                  ? file("../../build/secret/${keystoreProperties['storeFile']}") 
                  : null
            storePassword = keystoreProperties['storePassword']
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
        }
    }

    buildTypes {
        debug {
            signingConfig signingConfigs.debug
        }
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

The tricky part is now to tell BitBucket how to initialize the secret submodule.
To do so, you'll have to manually initialize the submodule in your pipeline file.

In your BitBucket's application repository, go to `Settings > Pipelines / Environment Variables`.
Add 2 new _secured_ environment variables for user (`BITBUCKET_USER`) and password
 (`BITBUCKET_PASS`). Use values allowed to clone your `secret` repository.

Finally trigger the submodule initialization using these secret credentials:

`bitbucket-pipelines.yml`:

``` yaml
pipelines:
  branches:
    master:
      - step:
          script:
            - git config --file=.gitmodules submodule.build/secret.url https://$BITBUCKET_USER:$BITBUCKET_PASS@bitbucket.org/shht/secrets.git
            - git submodule sync
            - git submodule update --init build/secret
            - ./gradlew assembleRelease
```

[Source](https://community.atlassian.com/t5/Bitbucket-questions/Bitbucket-Pipelines-and-git-submodules/qaq-p/130479).
