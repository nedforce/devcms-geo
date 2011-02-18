# This model is used to represent a GeoViewer. It has specified
# +acts_as_content_node+ from Acts::ContentNode::ClassMethods.
#
# *Specification*
#
# Attributes
#
# * +title+ - The title of the geo viewer.
# * +description+ - A description of the geo viewer
# * +map_settings+ - A serialized hash containing map configuration
# * +filter_settings+ - A serialized hash with filter configuration
#
# Preconditions
#
# * Requires the presence of +title+.
#
# * Map settings *
# The following map configuration options are available:
# * default_bounding_box - The default area to show
#
# * Filter settings *
# Specifies what default values are used for filtering and which filter options can be modified in the frontend
# The following filter configuration options are available:
# * Category - Filter on associated category
# * Scope - Filter on specific content types or within a certain subtree
# * Timeframe - Filter on last update timestamp
# * Permit & Legislation specific filters
class GeoViewer < ActiveRecord::Base
  
  acts_as_content_node({
    :allowed_roles_for_update  => %w( admin final_editor ),
    :allowed_roles_for_create  => %w( admin ),
    :allowed_roles_for_destroy => %w( admin ),
    :available_content_representations => ['content_box']
  })
  
  validates_presence_of :title
  validates_length_of   :title, :in => 2..255, :allow_blank => true
  
  serialize :filter_settings, :map_settings
  
end