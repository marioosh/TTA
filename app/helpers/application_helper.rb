# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def number_to_price(n)
    number_to_currency(n, :unit => 'zł')
  end

  def polish_paginate(collection)
    will_paginate collection, :prev_label => '&laquo; Poprzednie', :next_label   => 'Następne &raquo;'
  end

  def ends_with_dot(text)
    text.gsub(/[^\!\.\?]$/, '\\0.')
  end

  def set_title(title)
    title = strip_tags(title)
    content_for :title, title
  end

  def show_title(title)
    set_title(title)
    content_tag :h1, title unless title.nil?
  end

  def polish_plural(value, t1, t2, t5)
    # 1 samochod
    value = value.to_i
    return t1 if value == 1

    # 2, 3, 4, ..., 22, 23, ..., 104 samochody
    v = value > 20 ? value % 10 : value
    return t2 if [2,3,4].index v

    # 5, 6, ..., 10, 11, ..., 25 samochodow
    return t5
  end

  # Awesome truncate
  # First regex truncates to the length, plus the rest of that word, if any.
  # Second regex removes any trailing whitespace or punctuation (except ;).
  # Unlike the regular truncate method, this avoids the problem with cutting
  # in the middle of an entity ex.: truncate("this &amp; that",9)  => "this &am..."
  # though it will not be the exact length.
  def awesome_truncate(text, length = 30, truncate_string = "...")
    return if text.nil?
    l = length - truncate_string.chars.length
    text.chars.length > length ? text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
  end

  def create_breadcrumb(name, options = nil)
    if options.is_a? String
      url = options
    elsif options.is_a? Hash
      url = url_for options
    elsif options.is_a? Array
      options.each do |name, url|
        add_breadcrumb name, url
      end
      url = nil
    else
      url = nil
    end

    return [name, url]
  end

  def before_breadcrumb(name, options = nil)
    @breadcrumbs ||= []
    @breadcrumbs.insert 0, create_breadcrumb(name, options)
  end

  def add_breadcrumb(name, options = nil)
    @breadcrumbs ||= []
    @breadcrumbs << create_breadcrumb(name, options)
  end

  def single_breadcrumb(txt, url, html_options = {})
    unless url.nil? || url.empty?
      content_tag('li', link_to(strip_tags(txt), url), html_options)
    else
      content_tag('li', strip_tags(txt), html_options)
    end
  end

  def show_breadcrumbs(glue = '', html_options = {})
    if @breadcrumbs
      s = []
      s << single_breadcrumb('Jesteś tutaj:', nil, :class => 'first')
      @breadcrumbs[0..-2].each do |txt, url|
        s << single_breadcrumb(txt, url)
      end
      s << single_breadcrumb(@breadcrumbs.last[0], @breadcrumbs.last[1], :class => 'last')

      glue = content_tag('li', glue, :class => 'glue') unless glue.empty?
      content_tag 'ul', raw(s.join(glue)), html_options
    end
  end

  def layout_stylesheet
    stylesheet = controller.class.to_s.match('::') ? controller.class.to_s.gsub(/::.*/, '/').downcase : ''
    stylesheet + 'layout'
  end
end