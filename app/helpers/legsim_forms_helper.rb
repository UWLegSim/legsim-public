class LegSimFormBuilder < ActionView::Helpers::FormBuilder
  def date_time_picker(attribute, options={})
    options.merge!(
      :class => 'date-picker',
      :value => ( object.__send__(attribute) || Time.now ).to_s(:date_entry)
    )
    text_field( attribute, options )
  end

  def error_messages
    return unless object.respond_to?(:errors) && object.errors.any?

    error_messages = object.errors.full_messages.collect {|msg| @template.content_tag(:li, msg.html_safe) }.join

    @template.content_tag(:div,class: "alert-box") do
      @template.content_tag(:h2, "Error", class:'error')
      @template.content_tag(:ul, error_messages.html_safe)
    end
  end

end

module LegsimFormsHelper

  def form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    super(record_or_name_or_array, *(args << options.merge(:builder => LegSimFormBuilder)), &proc)
  end

  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys

    if object = options.delete(:object)
      objects = Array.wrap(object)
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end

    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = { :class => 'alert-box' }

      error_messages = objects.sum {|object| object.errors.collect {|err,msg| content_tag(:li, ERB::Util.html_escape(msg)) } }.join

      content_tag(:div, html) do
        content_tag(:h2, "Error", :class => "error")
        content_tag(:ul, error_messages.html_safe)
      end
    else
      ''
    end
  end

  def form_field(*args,&block)

    if block_given?
      options      = args.first || {}
      form_field( capture(&block), options)
    else
      form_element = args.first
      options      = args.second || {}

#       if options[:tip]
#         "<fieldset class=\"clearfix\">#{form_element} <a href=\"#whatisthis\" class=\"wit\"></a></fieldset>"
#       else
        "<fieldset class=\"clearfix\">#{form_element}</fieldset>".html_safe
#       end
    end

  end

#   def date_time_picker_tag( name )
#     f.text_field( name, :class=> 'date-picker' )
#   end

  def submit_tag(value = "Save changes", options = {})
    options = {
      :size =>  'thirty',
      :class => 'submit',
      :simple => false
    }.merge(options)

    if options[:simple]
      super( value, options )
    else
      "<div class='button #{options[:size]}'><div class='left'><div class='right'>#{ super( value, options ) }</div></div></div>".html_safe
    end
  end

  def link_button_to(name, url, options = {})
    options = {
      :size =>  'thirty',
      :class => 'submit',
      :simple => false
    }.merge(options)

    "<div class='button #{options[:size]}'><div class='left'><div class='right'>#{ link_to( name, url, options ) }</div></div></div>".html_safe
  end

  def tag(name, options = nil, open = false, escape = true)
    if name == 'input' and (options[:type] == 'submit' or options['type'] == 'submit')

      options = {
        :size =>  options['size'] || 'thirty',
        :class => 'submit',
      }.merge(options)

      "<div class='button #{options[:size]}'><div class='left'><div class='right'><#{name}#{tag_builder.tag_options(options, escape) if options}#{open ? ">" : " />"}</div></div></div>"
    else
      super
    end
  end

  private
  def tag_builder
    @tag_builder ||= ActionView::Helpers::TagHelper::TagBuilder.new(self)
  end

end