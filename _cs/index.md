---
title: CS
name: index
date: 0000-01-01
layout: post
---

<ul class="listing">
{% assign posts = site.cs | where_exp: "post", "post.name != 'index'" %}
{% for post in posts %}
  <li class="listing-item">
  <time datetime="{{ post.date | date:"%Y-%m-%d" }}">{{ post.date | date:"%Y-%m-%d" }}</time>
  <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>