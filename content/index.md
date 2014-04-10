---
title: Home & Resume
kind: resume
---
You are on the personal website of Olivier Patry (<olivier.patry@gmail.com>), software engineer working for [MyScript](http://www.myscript.com/) (handwriting recognition).

##About

Software engineer specialized in software **architecture** and **object oriented** programming for **mobile/embedded devices**.

##Knowledge
Languages & frameworks
:	**Java** (Android, J2ME, J2SE, OSGi), **C++**, Ant, CMake, &#8230;

Tools & operating systems
:	**Eclipse**, **Git**, Jazz RTC, GNU/Linux, Microsoft Windows, LaTeX, &#8230;

Methods
:	Object Oriented Patterns, Extreme programming Scrum, &#8230;

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
<% notes.each do |note| %>
<li><a href="<%= note.path %>"><%= note[:title] %></a></li>
<% end %>
</ul>
