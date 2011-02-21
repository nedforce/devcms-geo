require 'acts_as_content_node_geo_extensions'

# Extend ActiveRecord::Base with the +acts_as_content_node+ functionality.
ActiveRecord::Base.send(:include, Acts::ContentNode::GeoExtensions)
