---
title: Home & Resume
layout: markdown
tags: [Olivier Patry]
---
Welcome here! You are on the personal website of Olivier Patry, software engineer working for [Vision Objects](http://www.visionobjects.com/) (handwriting recognition).

##About
![](/images/authors/opatry.png)
28 years old.

Software engineer specialized in software **architecture** and **object oriented** programming for **embedded devices**.

email address: <olivier.patry@gmail.com>

##Knowledge
Languages & frameworks
:	**Java** (J2ME, J2SE, OSGi), **C++**, Ant, CMake, &#8230;

Tools & operating systems
:	**Eclipse**, Git, Jazz RTC, GNU/Linux, Microsoft Windows, LaTeX, &#8230;

Methods
:	Object Oriented Patterns, Extrem programming Scrum, MDE/MDA, &#8230;

##Spoken languages
* French: native speaker.
* English: fluent (Code documentation, Specifications reading & writing, World wide technical support).

##Hobbies
* Badminton (Active member and competitor)
* Running
* Reading

<hr>
<h2>Notes</h2>
<ul>
{% for post in site.posts %}
<li><a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
