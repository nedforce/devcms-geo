module DevcmsGeoHelper

  # Given an array of addresses, will return an image tag
  # with a static Google map plotting those points.
  def static_map_of_addresses(addresses, options = {})
    return if addresses.nil?

    alt = options.delete(:alt) || "A map of #{pluralize addresses.size, 'address'}"

    image_tag DevcmsGeo::StaticMap.for_addresses(addresses, options), alt: alt
  end
end
