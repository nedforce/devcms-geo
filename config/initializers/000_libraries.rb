require 'acts_as_content_node_geo_extensions'
require 'static_map'

if ActiveRecord::Base.connection.table_exists?('nodes')
  Node.send(:include, Node::GeoLocation)
end

ActiveRecord::Base.send(:include, Acts::ContentNode::GeoExtensions)
