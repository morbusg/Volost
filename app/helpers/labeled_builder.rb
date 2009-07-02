module ActionView::Helpers::FormHelper
  def apply_form_for_options!(object_or_array, options)
    object = object_or_array.is_a?(Array) ? object_or_array.last : object_or_array

    html_options =
      if object.respond_to?(:new_record?) && object.new_record?
        { :method => :post }
      else
        { :method => :put }
      end

    options[:html] ||= {}
    options[:html].reverse_merge!(html_options)
    options[:url] ||= polymorphic_path(object_or_array)
  end
end

class LabeledBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options={})
    label(method, I18n.t(method.to_sym)) + super
  end

  def text_area(method, options={})
    label(method, I18n.t(method.to_sym)) + super
  end

  def password_field(method, options={})
    label(method, I18n.t(method.to_sym)) + super
  end

  def check_box(method, options={}, checked_value="1", unchecked_value="0")
    label(method, I18n.t(method.to_sym)) + super
  end

  def date_select(method, options={}, html_options={})
    label(method, I18n.t(method.to_sym)) + super
  end
  
  def select(method, choices, options={}, html_options={})
    label(method, I18n.t(method.to_sym)) + super
  end

  def collection_select(method, collection, value_method, text_method, options={}, html_options={})
    label(method, I18n.t(method.to_sym)) + super
  end

  def file_field(method, options={})
    label(method, I18n.t(method.to_sym)) + super
  end

end
