---
title: GitHub Pages Memo
kind: note
created_at: 2013-03-02 12:00:00 +0200
---
# [Development Seed](http://developmentseed.org/) use case
Development Seed presents [useful tips for GitHub Pages](http://developmentseed.org/blog/2011/09/09/jekyll-github-pages/):

## Custom YAML properties
> The YAML header used by Jekyll provides for amazing flexibility. There are a few predefined fields that can be used tactically but you are free to add your own fields at will. Using these YAML fields you can add custom fields and create relations between content in a simple, straightforward, manner.

## Pseudo CSS Pre Generator (for mutiple CSS file merge)
> Aggregated CSS and JavaScript is a good idea for any website in production. Doing this with Jekyll turned out to be a snap. We put our individual CSS and JavaScript in the _includes directory. Then leveraging Rule #2 - any file with a YAML header (even an empty one) can use Liquid templating.

## Search
> While there are some search plugins for Jekyll, GitHub pages doesn’t support custom Jekyll plugins as of yet. We found an alternative, elegant solution by implementing a smart client-side JS autocomplete rather than a traditional keyword search.

# [GitHub Issues 2.0 Review](https://github.com/blog/831-issues-2-0-the-next-generation)

## Closing GitHub Issues at commit
> Issues has deep integration with commit messages. Any time you reference an issue number from a commit message, we'll bring in the commits to the discussion view for you.
