---
title: Home
layout: home
---

You are on the personal website of Olivier Patry, working at [MyScript](https://www.myscript.com/) as Apps Team lead.

MyScript develops handwriting recognition for text, math and diagram (see [developer portal](https://developer.myscript.com/)) and publishes SDK and Apps that leverage it.

## Apps

### ![](<%= @items['/images/calculator.*'].path %>) [Calculator](https://www.myscript.com/calculator/): handwriting calculator application

> **The easiest way to calculate**

Available on
  [iOS](https://apps.apple.com/us/app/myscript-calculator-handwriting-calculator/id1304488725) and
  [Android](https://play.google.com/store/apps/details?id=com.myscript.calculator).
{: .metadata}

### ![](<%= @items['/images/nebo.*'].path %>) [Nebo](https://www.nebo.app/): note taking application

> **The future of note‑taking**
> 
> Take smarter, more beautiful notes with the only app that makes handwriting as powerful as typed text.

Available on
 [iOS](https://apps.apple.com/us/app/myscript-nebo-best-way-to/id1119601770),
 [Android](https://play.google.com/store/apps/details?id=com.myscript.nebo) and
 [Windows](https://www.microsoft.com/en-us/p/nebo/9nblggh4nlb0).
{: .metadata}

<div class="centered-media">
<iframe width="560" height="315" src="https://www.youtube.com/embed/6iNqExuVra4?autoplay=0&amp;rel=0" allowfullscreen=""></iframe>
</div>

----

<div class="special-links" markdown="1">
[<span class="icon-twitter"></span>](https://twitter.com/o_patry)
[<span class="icon-github-circled"></span>](https://github.com/opatry)
[<span class="icon-rss-squared"></span>](/rss.xml)
</div>

----

## Notes
<% notes.each do |note| %>
* <%= link_to(note[:title], note.path) %> <span class="metadata">(<%= get_pretty_date(note, short: true) %>)</span>
<% end %>
