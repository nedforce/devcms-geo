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
    :allowed_roles_for_update          => %w( admin final_editor ),
    :allowed_roles_for_create          => %w( admin ),
    :allowed_roles_for_destroy         => %w( admin ),
    :available_content_representations => ['content_box']
  })
  
  validates_presence_of :title
  validates_length_of   :title, :in => 2..255, :allow_blank => true
  
  serialize :filter_settings
  serialize :map_settings
  
  def tree_icon_class
    'map_icon'
  end
  
  def icon_filename
    'map.png'
  end
  
  def filter_settings
    read_attribute(:filter_settings) || {}
  end
  
  def map_settings
    read_attribute(:map_settings) || {}
  end
  
  def nodes(filters = {})
    if !filters.nil?
      filters[:search_scope] ||= self.filter_settings[:search_scope]
      filters[:search_scope] ||= 'all'
    else
      filters = []
      filters[:search_scope] ||= 'all'
    end
    
    nodes = if filters[:search_scope] =~ /node_(\d+)/
      Node.find($1).self_and_descendants
    elsif filters[:search_scope] =~ /content_type_(\w+)/
      Node.scoped(:conditions => { :content_type => $1.classify })
    elsif filters[:search_scope] == 'all'
      Node.scoped({})
    end
    
    if filters[:from_date].present?
      nodes = nodes.published_after((Time.parse(filters[:from_date]) rescue nil))
    end
    if filters[:until_date].present?
      nodes = nodes.published_before((Time.parse(filters[:until_date]) rescue nil))
    end

    if filters[:search_scope] == 'content_type_permit'
      #Permit filters
      nodes = nodes.scoped(:joins => 'LEFT JOIN permits on permits.id = nodes.content_id AND nodes.content_type = \'Permit\'')
      nodes = nodes.scoped(:conditions => { :permits => { :phase_id        => filters[:permit_phase]       }}) if filters[:permit_phase].present?
      nodes = nodes.scoped(:conditions => { :permits => { :product_type_id => filters[:permit_product_type]}}) if filters[:permit_product_type].present?
    end

    if filters[:search_scope] == 'content_type_legislation'
      #Permit filters
      nodes = nodes.scoped(:joins => 'LEFT JOIN legislations on legislations.id = nodes.content_id AND nodes.content_type = \'Legislation\'')
      nodes = nodes.scoped(:conditions => { :legislations => { :subject => filters[:legislation_subject] }}) if filters[:legislation_subject].present?
    end

    if !nodes.nil? 
      return nodes.geo_coded.find_accessible(:all) 
    else
      return nil
    end

    return nodes.geo_coded.find_accessible(:all)
  end
end
