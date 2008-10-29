# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def spanned_link(*args)
    text = '<span>' + args.shift + '</span>'
    args = args.insert(0, text)
    link_to(*args)
  end
  
  def spanify_links(text)
    text.gsub(/<a\s+(.*)>(.*)<\/a>/i, '<a \1><span>\2</span></a>')
  end
  
  def partial_for(post)
    partial_path = logged_in? ? "/admin/posts/types/#{post.type.downcase}.html.erb" : "/posts/types/#{post.type.downcase}.html.erb"
    render :partial => partial_path, :locals => { :post => post }
  end
  
  def comments_link_for(post)
    text = (post.comments.length < 1) ? 'No comments' : pluralize(post.comments.length, 'comment')
    path = send("#{post.type.downcase}_path", post)
    link_to text, "#{path}#comments"
  end
  
  # TODO This method sucks. Learn about regex and fix it.
  def twitterize(string)
    string.gsub!(/\b(((http:|https:|file:)\/\/)?([a-z]+\.)?(\w+\.com|net|org)(\/.*)?)\b/) do
      "<a href='#{"http://" unless $1.include?('http://')}#{$1}'><span>#{$1}</span></a>"
    end
    string.gsub!(/@(\w*)/, '@<a href="http://twitter.com/\1"><span>\1</span></a>')
    string = auto_link(string)
    string = RubyPants.new(string).to_html
    spanify_links(string)
  end
  
  def clean_content_for(post)
    text = post.to_html
    text.gsub!(/<(script|noscript|object|embed|style|frameset|frame|iframe)[>\s\S]*<\/\1>/, '') if post.from_feed?
    text = spanify_links(text)
  end
  
  
  def edit_in_place_for(resource, field, options={})
    # Get record to be edited. If resource is an array, pull it out.    
    record = resource.is_a?(Array) ? resource.last : resource
    
    options[:id]  ||= "#{dom_id(record)}_#{field}"
    options[:tag] ||= :div
    options[:url] ||= url_for(resource)
    options[:rel] = options.delete(:url)

    classes = options[:class].try(:split, ' ') || []
    classes << 'editable'
    options[:class] = classes.uniq.join(' ')

    content_tag(options[:tag], record.send(field), options)
  end
  
  def flash_message(name)
    %(<p class="flash #{name}">#{flash[name]}</p>) if flash[name]
  end
  
  def host_helper
    if RAILS_ENV == 'development'
      request.host_with_port
    else
      request.host
    end
  end
  
  def relative_url_helper
    ActionController::Base.respond_to?('relative_url_root=') ? ActionController::Base.relative_url_root : ActionController::AbstractRequest.relative_url_root
  end

  def feed_url_for(post)
    case post
    when Tweet, Link
      post.permalink
    else
      post.from_feed? ? post.permalink : "http://#{host_helper}#{url_for(post)}"
    end
  end
  
  def feed_tag(name, options={})
    name_str = (name || @post_type).to_s.gsub('/','')
    options[:format] ||= :rss
    options[:title] ||= "#{name_str.titleize} Only (#{options[:format].to_s.upcase})"
    options[:url] ||= SITE_SETTINGS[:feedburner][(name || 'all')] || "http://#{host_helper}#{relative_url_helper}/#{name_str}.rss"
    auto_discovery_link_tag options[:format], options[:url], :title => options[:title]
  end
  
  def admin?
    @admin = true
  end
  
end
