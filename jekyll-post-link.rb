# post_link
# http://brm.io/jekyll-post-links/
# 
# usage {% post_link post text %}
# 
# Where post is a post in the usual date-slug format.
# If text is specified, it uses that as the anchor text, otherwise it's the post title.
# 
# Output is a full anchor tag. Broken links will be detected by compiler.
# 
# based on post_url.rb
# https://github.com/jekyll/jekyll/blob/master/lib/jekyll/tags/post_url.rb

module Jekyll
  module Tags
    class PostLinkComparer
      MATCHER = /^(.+\/)*(\d+-\d+-\d+)-([^\s]*)(\s.*)?$/

      attr_accessor :date, :slug, :text

      def initialize(name)
        all, path, date, slug, text = *name.sub(/^\//, "").match(MATCHER)
        raise ArgumentError.new("'#{name}' does not contain valid date and/or title") unless all
        @slug = path ? path + slug : slug
        @date = Time.parse(date)
        @text = text
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
        path = other.name.split("/")[0...-1].join("/")
        if path.nil? || path == ""
          other.slug
        else
          path + '/' + other.slug
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
        
        # check if the site is in staging mode and use dummy links
        if not Dir["./_stash/*"].empty?
          # staging mode
          return "<a href=\"http://flohei.de\">Temporary Staging Link</a>" 
        end

        site.posts.each do |p|
          if @post == p
            return "<a href=\"#{ p.url }\">#{ @post.text ? @post.text.strip! : p.title }</a>"
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