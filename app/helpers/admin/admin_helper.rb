module Admin::AdminHelper

  def default_fields_after_form_with_geo_fields(form)
    default_fields_after_form_without_geo_fields(form) +
    content_tag(:div, :id => 'geo_data') do
      content_tag(:fieldset) do
        content_tag(:legend, t('shared.geo_data')) +
        form.text_field(:location, :label => t('shared.location')) + 
        wrap_with_label(form.select(:pin_id, Pin.all.map{|p| [ p.title, p.id ] }, :include_blank => '-'), { :text => Node.human_attribute_name(:pin_id), :for => 'page_pin_id' })
      end
    end
  end
  alias_method_chain :default_fields_after_form, :geo_fields

end
