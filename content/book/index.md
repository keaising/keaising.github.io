---
title: 我读
name: index
layout: collection-index
intro: 我读过的书不多，希望能多记住一些
date: 2019-10-26
---

<ul class="listing">
{% assign posts = site.book | where_exp: "post", "post.name != 'index'" %}
{% for post in posts %}
  <li class="listing-item">
  <time datetime="{{ post.date | date:"%Y-%m-%d" }}">{{ post.date | date:"%Y-%m-%d" }}</time>
  <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>