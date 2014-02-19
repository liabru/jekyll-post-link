# jekyll-post-link.rb #

[http://brm.io/jekyll-post-links/](http://brm.io/jekyll-post-links/)

I modified the original [post_url source](http://jekyllrb.com/docs/templates/#post_url) to generate a complete anchor tag with the url _and_ title all pulled from the post. You can optionally change the link text too. I prefer this to manually typing post links since this helps keep them up to date during development, even if you change permalinks, and the compiler will warn if you accidentally a broken link.

## Usage ##

Drop the `jekyll-post-link.rb` file in your `_plugins` directory and you're good to go.

Usage of `post_link` is as follows:

	{% post_link post text %}

Where `post` is a post in the usual date-slug format.
<br>_Optional_: if specified `text` is the anchor text, otherwise it's the post title