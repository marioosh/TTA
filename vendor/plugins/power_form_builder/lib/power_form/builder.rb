class PowerForm::Builder < ActionView::Helpers::FormBuilder

  #  <div class="field text_field required invalid" id="field-user_email">
  #    <label for="user_email">
  #      E-mail
  #      <span>(wymagane)</span>
  #    </label>
  #    <div class="input">
  #      <input type="text" id="user_email" name="user[email]" />
  #    </div>
  #    <p class="hint">Podaj swój adres e-mail.</p>
  #    <p class="error">Nieprawidłowy adres e-mail.</p>
  #  </div>
  def text_field(field_name, options = {})
    power_options = power_options!(field_name, options)
    generic_field(:text_field, super(field_name, options), field_name, power_options)
  end

  def password_field(field_name, options = {})
    power_options = power_options!(field_name, options)
    generic_field(:password_field, super(field_name, options), field_name, power_options)
  end

  def password_field(field_name, options = {})
    power_options = power_options!(field_name, options)
    generic_field(:password_field, super(field_name, options), field_name, power_options)
  end

  def check_box(field_name, options = {})
    power_options = power_options!(field_name, options)
    power_options[:reverse] = true
    generic_field(:check_box, super(field_name, options), field_name, power_options)
  end

  def select(field_name, choices, options = {}, html_options = {})
    power_options = power_options!(field_name, options)
    generic_field(:select, super(field_name, choices, options, html_options), field_name, power_options)
  end

  def collection_select(field_name, collection, value_method, text_method, options = {}, html_options = {})
    power_options = power_options!(field_name, options)
    generic_field(:select, super(field_name, collection, value_method, text_method, options, html_options), field_name, power_options)
  end

  def time_zone_select(field_name, priority_zones = nil, options = {}, html_options = {})
    power_options = power_options!(field_name, options)
    generic_field(:select, super(field_name, priority_zones, options, html_options), field_name, power_options)
  end

  def text_area(field_name, options = {})
    power_options = power_options!(field_name, options)
    generic_field(:text_area, super(field_name, options), field_name, power_options)
  end

  def check_box_group(field_name, choices, options = {})
    power_options = power_options!(field_name, options)
    power_group = power_check_box_group(field_name, choices, options)
    generic_field(:check_box_group, power_group, field_name, power_options)
  end

  def collection_check_box_group(field_name, collection, value_method, text_method, options = {})
    choices = []
    collection.each do |item|
      choices << [item.send(text_method), item.send(value_method)]
    end
    check_box_group(field_name, choices, options)
  end

  def radio_group(field_name, choices, options = {})
    power_options = power_options!(field_name, options)
    power_group = power_radio_group(field_name, choices, options)
    generic_field(:radio_group, power_group, field_name, power_options)
  end

  def collection_radio_group(field_name, collection, value_method, text_method, options = {})
    choices = []
    collection.each do |item|
      choices << [item.send(text_method), item.send(value_method)]
    end
    radio_group(field_name, choices, options)
  end

  # TODO: select with name[]
  def select_multi(field_name, choices, options = {})
    power_options = power_options!(field_name, options)
    # generic_field(:select, super(field_name, choices, options), field_name, power_options)
    generic_field(:select, 'SELECT MULTI', field_name, power_options)
  end

  # TODO: http://docs.jquery.com/UI/Datepicker, http://www.compulsivoco.com/2008/06/inline-jquery-datepicker-and-rails/
  def date_picker(field_name, options = {})
    power_options = power_options!(field_name, options)
    field = power_date_picker(field_name, options)
    generic_field(:date_picker, field, field_name, power_options)
  end

  def submit(*args, &block)
    options = args.extract_options!
    label = options.delete(:label) || (block_given? ? block.call : args.first)
    power_options = power_options!(:submit, options)

    # label goes into submit button itself
    power_options.delete(:label)
    generic_field(:submit, power_submit(label, options), :submit, power_options)
  end

  def generic_field(field_type, field_html, field_name, options = {})
    html_required = options[:required] ? @template.content_tag(:span, '(' + t('forms.required') + ')') : ''
    html_label = @template.content_tag(:label, ((options[:label]).to_s + html_required).html_safe, :for => field_id(field_name))
    html_hint = options[:hint] ? @template.content_tag(:p, options[:hint], :class => :hint) : ''
    html_error = options[:error] ? @template.content_tag(:p, options[:error], :class => :error) : ''
    html_input = @template.content_tag(:div, field_html, :class => :input)

    html_row = options[:reverse] ? html_input + html_label : html_label + html_input
    html_row += html_hint + html_error

    return @template.content_tag(:div, html_row, :id => row_id(field_name), :class => row_class(field_type, options[:required], options[:error]))
  end

  protected

#    <script type="text/javascript">
#      $(document).ready(function(){
#        $("#datepicker").datepicker();
#      });
#    </script>
#    <div type="text" id="datepicker"></div>
    def power_date_picker(field_name, options = {})
      return 'DATE PICKER'
    end

    def power_radio_group(field_name, choices, options = {})
      hidden_options = options.merge(:name => field_name(field_name), :type => 'hidden')
      html_input = @template.tag(:input, hidden_options)

      choices.each do |name, value|
        value = value.to_s if value.is_a? Symbol
        label = @template.content_tag(:label, name.to_s, :for => field_id(field_name, value))
        input = radio_button(field_name, value, options)
        html_input << @template.content_tag(:span, input + label, :id => input_id(field_name, value))
      end

      return html_input
    end

    def power_check_box_group(field_name, choices, options = {})
      # hidden tag
      hidden_options = options.merge(:name => field_name(field_name, true), :type => 'hidden')
      html_input = @template.tag(:input, hidden_options)

      options.merge!(:name => field_name(field_name, true), :type => 'checkbox')
      choices.each do |name, value|
        value = value.to_s if value.is_a? Symbol
        label = @template.content_tag(:label, name.to_s, :for => field_id(field_name, value))

        # we don't use FormHelper because we don't need the "unchecked" hidden input
        options.merge!(:id => field_id(field_name, value), :value => value)
        options[:checked] = field_value(field_name).include?(value) unless field_value(field_name).nil?
        input = @template.tag(:input, options)
        
        html_input << @template.content_tag(:span, input + label, :id => input_id(field_name, value))
      end

      return html_input
    end

    def power_submit(label, options = {})
      options.merge!(:type => :submit)
      options.merge!(:id => field_id(:submit))
      @template.content_tag(:button, label, options)
    end

    def power_options!(field_name, options = {})
      power_options = {}
      power_options[:label]    = options.delete(:label)    || field_name.to_s.humanize
      power_options[:required] = options.delete(:required) || false
      power_options[:hint]     = options.delete(:hint)     || false
      power_options[:reverse]  = options.delete(:reverse)  || false

      if options[:error]
        power_options[:error]  = options.delete(:error)
      elseif object && object.respond_to?('errors')
        errors = object.errors.on(field_name.to_sym)
        power_options[:error] = errors.is_a?(Array) ? errors.first : errors if errors
      end

      return power_options
    end

    # from ActionView::Helpers:InstanceTag
    def object
      @object ||= @template.instance_variable_get("@#{@object_name}")
    end

    # from ActionView::Helpers:InstanceTag
    def sanitized_object_name
      @sanitized_object_name ||= @object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end
    
    # from ActionView::Helpers:InstanceTag
    def sanitized_field_name(field_name)
      field_name.to_s.sub(/\?$/,"")
    end

    # from ActionView::Helpers:InstanceTag
    def field_value(field_name)
      object.send field_name unless object.nil?
    end

    # from ActionView::Helpers:InstanceTag
    def field_name(field_name, multiple = false)
      name = "#{@object_name}[#{sanitized_field_name(field_name)}]"
      name << '[]' if multiple
      return name
    end

    # from ActionView::Helpers:InstanceTag
    def field_id(field_name, index = nil)
      name = sanitized_object_name + '_' + sanitized_field_name(field_name)
      name << '_' + index.to_s.gsub(/\s/, "_").gsub(/\W/, "").downcase unless index.nil?
      return name
    end

    def input_id(field_name, index)
      'input-' + field_id(field_name, index)
    end

    def row_id(field_name)
      'field-' + field_id(field_name)
    end

    def row_class(field_type, required, error)
      classes = [ 'field', field_type ]
      classes << 'required' if required
      classes << 'invalid' if error
      classes.join " "
    end

    # I18n.translate()
    def t(*args)
      @template.t(*args)
    end

end