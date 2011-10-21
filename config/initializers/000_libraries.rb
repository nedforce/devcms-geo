require 'acts_as_content_node_geo_extensions'
require 'static_map'

Node.send(:include, Node::GeoLocation)

ActiveRecord::Base.send(:include, Acts::ContentNode::GeoExtensions)
