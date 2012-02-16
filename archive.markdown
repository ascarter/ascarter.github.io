---
layout: default
title: Archive
---

<div id="archive">
    <ul>
        {% for post in site.posts  %}
        <li><span class="title"><a href="{{ post.url }}">{{ post.title | xml_escape }}</a></span><span class="date">{{ post.date | date_to_long_string }}</span></li>
        {% endfor %}
    </ul>
</div>
