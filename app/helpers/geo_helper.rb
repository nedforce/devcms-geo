module GeoHelper

  # Given an array of addresses, will return an image an
  # image tag with a static google map plotting those points.
  def static_map_of_addresses(addresses, options = {})
    if !addresses.nil?
      image_tag(StaticMap.for_addresses(addresses, options), :alt => "A map of #{pluralize addresses.size, "address"}")
    end
  end
end
