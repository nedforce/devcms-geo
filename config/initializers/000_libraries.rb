require 'static_map'

if ActiveRecord::Base.connection.table_exists?('nodes')
  Node.send(:include, Node::GeoLocation)
end
