module Admin::AdminHelper
  
  def default_fields_after_form_with_geo_fields(form)
    default_fields_after_form_without_geo_fields(form) +
    content_tag(:div, :id => "geo_data") do
      content_tag(:fieldset) do
        content_tag(:legend, t('shared.geo_data'))+
        form.text_field(:location, :label => t('shared.location'))
      end
    end
  end
  
  alias_method_chain :default_fields_after_form, :geo_fields
  
end