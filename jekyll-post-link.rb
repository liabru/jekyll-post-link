# post_link
# https://github.com/liabru/jekyll-post-link
#
# usage {% post_link post text %}
# License: MIT
#
# Where post is a post in the usual date-slug format.
# If text is specified, it uses that as the anchor text, otherwise it's the post title.
# Output is a full anchor tag. Broken links will be detected by compiler.
#
# Based on post_url.rb (licensed under MIT)
# https://github.com/jekyll/jekyll/blob/master/lib/jekyll/tags/post_url.rb
# Copyright (c) 2008-2017 Tom Preston-Werner and Jekyll contributors

module Jekyll
  module Tags
    class PostLinkComparer
      MATCHER = %r!^(.+/)*(\d+-\d+-\d+)-(.*)$!.freeze

      attr_reader :path, :date, :slug, :name

      def initialize(name)
        @name = name

        all, @path, @date, @slug = *name.sub(%r!^/!, "").match(MATCHER)
        unless all
          raise Jekyll::Errors::InvalidPostNameError,
                "'#{name}' does not contain valid date and/or title."
        end

        basename_pattern = "#{date}-#{Regexp.escape(slug)}\\.[^.]+"
        @name_regex = %r!^_posts/#{path}#{basename_pattern}|^#{path}_posts/?#{basename_pattern}!
      end

      def ==(other)
        slug == post_slug(other)

        # disabled the date check below (used in post_url.rb)
        # otherwise posts with a custom date front-matter will fail if it's different to the slug

        #&& date.year  == other.date.year &&
        #date.month == other.date.month &&
        #date.day   == other.date.day
      end

      private
      def post_slug(other)
        path = other.basename.split("/")[0...-1].join("/")
        if path.nil? || path == ""
          other.data["slug"]
        else
          path + '/' + other.data["slug"]
        end
      end
    end

    class PostLink < Liquid::Tag
      def initialize(tag_name, post, tokens)
        super
        @orig_post = post.strip
        begin
          @post = PostLinkComparer.new(@orig_post)
        rescue
          raise ArgumentError.new <<-eos
Could not parse name of post "#{@orig_post}" in tag 'post_link'.

Make sure the post exists and the name and date is correct.
eos
        end
      end

      def render(context)
        site = context.registers[:site]

        site.posts.docs.each do |p|
          if @post == p
            return "<a href=\"#{ p.url }\">#{ p.data["title"] }</a>"
          end
        end

        raise ArgumentError.new <<-eos
Could not find post "#{@orig_post}" in tag 'post_link'.

Make sure the post exists and the name and date is correct.
eos
      end
    end
  end
end

Liquid::Template.register_tag('post_link', Jekyll::Tags::PostLink)
