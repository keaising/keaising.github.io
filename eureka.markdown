---
title: Eureka!
layout: default
---

<ul class="listing">
{% assign collections = site.collections | where_exp: "al", "al.name > ''" %}
{% for al in collections %}
  <li class="listing-seperator" id="{{ al.name }}">
  <a href="{{ al.url }}" title="{{ al.name }}">{{ al.name }}</a>
  </li>
  {% assign posts = al.docs | where_exp: "post", "post.name != 'index'" %}
  {% for post in posts %}
  <li class="listing-item">
  <time datetime="{{ post.date | date:"%Y-%m-%d" }}">{{ post.date | date:"%Y-%m-%d" }}</time>
  <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
  </li>
{% endfor %}
{% endfor %}
</ul>

