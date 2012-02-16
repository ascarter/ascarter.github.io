---
layout: default
title: home
---

{% for post in site.posts limit:3 %}
{% include postdetail.html %}
{% endfor %}

## [Archive](/archive.html)

