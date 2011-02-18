module Admin::AdminHelper
  
  def default_fields_after_form_with_geo_fields(form)
    default_fields_after_form_without_geo_fields(form) +
    form.text_field(:location, :label => t('shared.location'))
  end
  
  alias_method_chain :default_fields_after_form, :geo_fields
  
end