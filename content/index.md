---
title: Home
kind: resume
---
You are on the personal website of Olivier Patry, software engineer working for [MyScript](https://myscript.com/) (handwriting recognition for text, math, geometry, diagram: [developer portal](https://developer.myscript.com/)).

Specialized in software **architecture** and **object oriented** programming for **mobile/embedded devices** mainly using
**Kotlin**, **Java** and **C++** (Android &amp; Desktop).

I'm currently working as MyScript's Mobile Application Program Manager.

![](images/nebo.svg) [Nebo](https://www.myscript.com/nebo/): note taking application<br>
![](images/calculator.svg) [Calculator](https://www.myscript.com/calculator/): handwriting calculator application

<div style="margin: 0 auto; width: 560px; max-width: 100%;">
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
* [<%= note[:title] %>](<%= note.path %>)
<% end %>
