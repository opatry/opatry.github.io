---
title: Home
layout: home
---

![](https://www.gravatar.com/avatar/3eae340e049abecfb4a117ad7a907bd1?s=256&d=mp)
{: .avatar}

# Olivier Patry

Engineering Manager & Senior software engineer
{: .subtitle}

## Summary
Engineering Manager with 15 years of experience, including 8 years leading mobile development teams. Proven track record in delivering high-quality software, and fostering team growth. Expertise in Android development, domain and business logic integration, and release management.

See my [resume](<%= @items['/resume.*'].path %>).
{: .metadata}

## Projects
<div class="project-cards">
<%= project_card(@items['/projects/nebo.*'], @items['/static/assets/projects/nebo.*'].path, 'MyScript Nebo', 'January 2015 — September 2024') %>
<%= project_card(@items['/projects/calculator.*'], @items['/static/assets/projects/calculator.*'].path, 'MyScript Calculator', 'August 2017 — January 2019') %>
<%= project_card(@items['/projects/stanza.*'], @items['/static/assets/projects/stanza.*'].path, 'Concept Stanza — Dell Innovation | Singapore', 'August 2021 — January 2022') %>
<%= project_card(@items['/projects/tydom.*'], @items['/static/assets/projects/tydom.*'].path, 'TYDOM — Delta Dore', 'January 2012 — January 2013') %>
<%= project_card(@items['/projects/taskfolio.*'], @items['/static/assets/projects/taskfolio.*'].path, 'Taskfolio', 'September 2024 — October 2024') %>
</div>

---

<div class="special-links" markdown="1">
[<span class="icon-linkedin" title="opatry on LinkedIn"></span>](https://www.linkedin.com/in/opatry)
[<span class="icon-twitter" title="o_patry on Twitter"></span>](https://twitter.com/o_patry)
[<span class="icon-github" title="opatry on Github"></span>](https://github.com/opatry)
[<span class="icon-mastodon" title="androiddev.social/@opatry on Mastodon"></span>](https://androiddev.social/@opatry)
[<span class="icon-rss2"></span>](<%= @items['/rss.*'].path %>)
</div>
