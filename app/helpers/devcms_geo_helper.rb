module DevcmsGeoHelper

  def default_fields_after_form(form)
    after_form_fields = super
    geo_data_block = render '/admin/geo_viewers/geo_data_fields', :form => form
    raw [after_form_fields, geo_data_block].join
  end

  # Given an array of addresses, will return an image an
  # image tag with a static Google map plotting those points.
  def static_map_of_addresses(addresses, options = {}, alt)
    if !addresses.nil?
      alt = "A map of #{pluralize addresses.size, "address"}" if !alt

      image_tag(DevcmsGeo::StaticMap.for_addresses(addresses, options), :alt => alt)
    end
  end
end
