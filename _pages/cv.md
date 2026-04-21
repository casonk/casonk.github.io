---
layout: single
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

## Profile

Data Systems Engineer at Robert Bosch LLC with graduate work and public repositories spanning simulation, analytics, developer tooling, and infrastructure automation.

## Experience

- Data Systems Engineer, Robert Bosch LLC
- Research assistant, University of Michigan-Flint

## Education

- Graduate study in Computer Science & Information Systems, University of Michigan-Flint

## Selected Software & Research

<ul>
{% for post in site.publications reversed %}
  <li><a href="{{ base_path }}{{ post.url }}">{{ post.title }}</a>{% if post.venue %}, {{ post.venue }}{% endif %}{% if post.date %} ({{ post.date | date: "%Y" }}){% endif %}</li>
{% endfor %}
</ul>

## Selected Projects

{% assign sorted_portfolio = site.portfolio | sort: "date" | reverse %}
<ul>
{% for post in sorted_portfolio %}
  <li><a href="{{ base_path }}{{ post.url }}">{{ post.title }}</a>{% if post.excerpt %} — {{ post.excerpt | markdownify | strip_html }}{% endif %}</li>
{% endfor %}
</ul>

## Talks and Workshops

<ul>
{% for post in site.talks reversed %}
  <li><a href="{{ base_path }}{{ post.url }}">{{ post.title }}</a>{% if post.venue %} — {{ post.venue }}{% endif %}{% if post.date %} ({{ post.date | date: "%B %Y" }}){% endif %}</li>
{% endfor %}
</ul>

## Links

- [GitHub](https://github.com/{{ site.author.github }})
- [LinkedIn](https://www.linkedin.com/in/{{ site.author.linkedin }})
