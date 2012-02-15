---
layout: default
title: Archive
---

<div id="archive">
    <ul>
        {% for post in site.posts  %}
        <li><span class="name"><a href="{{ post.url }}">{{ post.title | xml_escape }}</a></span><span class="date">{{ post.date | date: "%b %d %Y" }}</span></li>
        {% endfor %}
    </ul>
</div>