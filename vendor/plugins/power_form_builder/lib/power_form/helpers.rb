module PowerForm::Helpers

  def self.included base #:nodoc:
    # Create power_ prefixed helpers for each std rails form method
    helpers = %w(remote_form_for form_remote_for fields_for)
    helpers.each do |helper|
      self.module_eval <<-EVAL
        def power_#{helper} name, *args, &block
          options = args.extract_options!
          options[:html] ||= {}
          options[:html].merge!(:class => 'powerForm-body')
          options.merge!(:builder => PowerForm::Builder)
          args.push options
          #{helper} name, *args, &block
        end
      EVAL
    end
  end

  def power_fields_for name, *args, &block
    options = args.extract_options!
    options.merge!(:builder => PowerForm::Builder)
    args.push options

    fields_for name, *args, &block
  end

  def power_form_for name, *args, &block
    options = args.extract_options!
    options[:html] ||= {}
    options[:html].merge!(:class => 'powerForm-body', :method => :post)
    options.merge!(:builder => PowerForm::Builder)
    args.push options

    form_for name, *args, &block
  end

  def power_errors_for(*params)
    options = params.extract_options!.symbolize_keys

    objects = {}
    params.each do |p|
      object = instance_variable_get("@#{p}")
      if object && object.respond_to?('errors')
        objects[p] = object unless object.errors.count == 0
      end
    end

    unless objects.empty?
      html = {}
      html[:class] = options[:class] || 'powerForm-errors'

      error_messages = []
      objects.each do |name, object|
        object.errors.each do |key, msg|
          msg = content_tag(:a, ERB::Util.html_escape(msg), :href => '#field-' + [name, key].join("_"))
          error_messages << content_tag(:li, msg)
        end
      end

      contents = []
      contents << content_tag(:h2, options[:header_message]) if options[:header_message]
      contents << content_tag(:p, options[:message]) if options[:message]
      contents << content_tag(:ul, error_messages.join.html_safe)
      content_tag(:div, contents.join.html_safe, html)
    else
      ''
    end
  end
end