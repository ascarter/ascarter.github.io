---
layout: default
title: Archive
---

<div id="archive">
    <ul>
        {% for post in site.posts  %}
        <li>
            <p><span class="title"><a href="{{ post.url }}">{{ post.title }}</a></span></p>
            <p><span class="summary">{{ post.date | date_to_long_string }}</span></p>
        {% endfor %}
    </ul>
</div>
