# jekyll-post-link.rb #

[http://brm.io/jekyll-post-links/](http://brm.io/jekyll-post-links/)

This plugin generates a complete anchor tag with the url _and_ title all pulled from the post. You can optionally change the link text.

## Usage ##

Copy the `jekyll-post-link.rb` file into your `_plugins` directory.

Usage:

	{% post_link post text %}

Where `post` is a post in the usual date-slug format.
<br>_Optional_: if specified `text` is the anchor text, otherwise it's the post title