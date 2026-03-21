---
layout: archive
title: "Software & Research"
permalink: /publications/
author_profile: false
---

{% if site.author.googlescholar %}
  You can also find my articles on <u><a href="{{ site.author.googlescholar }}">Google Scholar</a></u>.
{% endif %}

{% include base_path %}

{% if site.publications.size > 0 %}
  {% for post in site.publications reversed %}
    {% include archive-single.html %}
  {% endfor %}
{% else %}
No software releases or research outputs are published here yet.
{% endif %}
