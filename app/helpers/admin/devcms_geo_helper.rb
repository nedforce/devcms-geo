module Admin::DevcmsGeoHelper

  def default_fields_after_form(form)
    after_form_fields = defined?(super) ? super : ''
    geo_data_block = render '/admin/geo_viewers/geo_data_fields', form: form
    raw [after_form_fields, geo_data_block].join
  end

end