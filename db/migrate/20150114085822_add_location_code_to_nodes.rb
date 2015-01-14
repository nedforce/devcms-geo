class AddLocationCodeToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :location_code, :string
  end

  ########
  ## Data migration
  # Node.where("location != '' and location is not null and content_type != 'Permit' and location_code is null").find_in_batches(:batch_size => 10) do |group| 
  #   group.each do |n|
  #     geocode = Node.try_geocode(n.location, :bias => Node.geocoding_bias)
  #     n.update_attribute :location_code, "#{geocode.zip} #{geocode.street_number}".gsub(/\s+/, "") rescue true
  #   end
  #   sleep 1 # keep within rate limit of 10/sec
  # end

end
