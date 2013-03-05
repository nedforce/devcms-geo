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
# * +combined_viewer+ - Boolean specifying that the viewer is a 'combined viewer', i.e. it represents several geo viewers.
#
# Preconditions
#
# * Requires the presence of +title+.
#
# *Map settings*
# The following map configuration options are available:
# * default_bounding_box - The default area to show
#
# *Filter settings*
# Specifies what default values are used for filtering and which filter options can be modified in the frontend
# The following filter configuration options are available:
# * Category - Filter on associated category
# * Scope - Filter on specific content types or within a certain subtree
# * Timeframe - Filter on last update timestamp
# * Permit & Legislation specific filters
class GeoViewer < ActiveRecord::Base
  
  has_many :pins, :dependent => :destroy
  
  # Can have many geo viewers (= combined geo viewer)
  has_many :geo_viewer_placeables, :foreign_key => :combined_geo_viewer_id, :class_name => 'GeoViewerPlacement', :dependent => :destroy
  has_many :geo_viewers, :through => :geo_viewer_placeables
  
  # Can have been included by several combined geo viewers
  has_many :geo_viewer_placements, :foreign_key => :geo_viewer_id, :dependent => :destroy  
  has_many :combined_geo_viewers, :through => :geo_viewer_placements
  
  named_scope :combined, :conditions => { :combined_viewer => true }
  named_scope :without_combined, :conditions => ['combined_viewer is null or combined_viewer = ?', false]
  
  accepts_nested_attributes_for :geo_viewer_placeables, :allow_destroy => true
  
  attr_readonly :combined_viewer
  
  acts_as_content_node({
    :allowed_roles_for_update           => %w( admin final_editor ),
    :allowed_roles_for_create           => %w( admin ),
    :allowed_roles_for_destroy          => %w( admin ),
    :available_content_representations  => ['content_box'],
    :has_own_content_box                => true    
  })

  validates_presence_of :title
  validates_length_of   :title, :in => 2..255, :allow_blank => true

  serialize :filter_settings
  serialize :map_settings
  
  def after_initialize 
    self.link_titles = true if link_titles.nil? && new_record?
  end
  
  def image_for(node)
    scope = Image.accessible.scoped(:include => :node, :conditions => { :is_for_header => [nil, false] })
    image = scope.first(:conditions => { 'nodes.ancestry' => node.child_ancestry })
    image = scope.first(:conditions => { 'nodes.ancestry' => node.parent.child_ancestry }) if inherit_images? && !image && node.parent.present?
    
    return image
  end
  
  def has_own_content_representation?
    @has_own_content_representation ||= node.content_representations.any?{|cr| cr.custom_type == 'related_content' && cr.parent_id == node.id }
  end  

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

  def nodes
    if combined_viewer?
      conditions = placeable_conditions      
      # Return scope or ensure an empty scope is returned otherwise
      conditions.present? ? Node.scoped(:conditions => conditions) : Node.scoped(:conditions => { :id => -1 })
    else
      Node.scoped({})
    end
  end
  
  def filtered_nodes(filters = {}, options = {})
    filters = self.filter_settings.merge(filters)
    filters[:search_scope] ||= 'all'

    filtered_node_scope = if combined_viewer?
      nodes.scoped(:conditions => placeable_conditions(:selection => filters[:layers], :toggled_only_for_empty_selection => true))
    else
      if filters[:search_scope] =~ /node_(\d+)/
        (node.id == $1.to_i ? parent : Node.find($1)).subtree
      elsif filters[:search_scope] =~ /content_type_(\w+)/
        nodes.scoped(:conditions => { :content_type => $1.classify })
      else
        nodes        
      end
    end

    if filters[:from_date].present?
      filtered_node_scope = filtered_node_scope.published_after(Time.parse(filters[:from_date])) rescue filtered_node_scope
    end
    if filters[:until_date].present?
      filtered_node_scope = filtered_node_scope.published_before(Time.parse(filters[:until_date])) rescue filtered_node_scope
    end
    
    if !combined_viewer?
      if filters[:search_scope] == 'content_type_permit'
        #Permit filters
        filtered_node_scope = filtered_node_scope.scoped(:joins => 'LEFT JOIN permits on permits.id = nodes.content_id AND nodes.content_type = \'Permit\'')
        filtered_node_scope = filtered_node_scope.scoped(:conditions => { :permits => { :phase_id        => filters[:permit_phase]       }}) if filters[:permit_phase].present?
        filtered_node_scope = filtered_node_scope.scoped(:conditions => { :permits => { :product_type_id => filters[:permit_product_type]}}) if filters[:permit_product_type].present?
      elsif filters[:search_scope] == 'content_type_legislation'
        #Permit filters
        filtered_node_scope = filtered_node_scope.scoped(:joins => 'LEFT JOIN legislations on legislations.id = nodes.content_id AND nodes.content_type = \'Legislation\'')
        filtered_node_scope = filtered_node_scope.scoped(:conditions => { :legislations => { :subject => filters[:legislation_subject] }}) if filters[:legislation_subject].present?
      end
    end

    return filtered_node_scope.geo_coded.accessible.scoped(options) 
  end
  
  # Combined viewer methods
  def toggled_placeable_ids
    @toggled_placeable_ids ||= geo_viewer_placeables.toggled.map(&:id)    
  end
  
  def placeable_conditions(options = {})
    placeables = if options[:selection].present? && (selection = (options[:selection].to_a.map(&:to_i) & geo_viewer_placeables.toggable.map(&:id))).present?
      geo_viewer_placeables.scoped(:conditions => ['geo_viewer_placements.id IN (?) or (geo_viewer_placements.is_toggled = ? and (geo_viewer_placements.is_toggable is null or geo_viewer_placements.is_toggable = ?))', selection, true, false])
    elsif options[:toggled_only_for_empty_selection]
      geo_viewer_placeables.toggled
    else
      geo_viewer_placeables
    end
    
    conditions = []
    placeables.scoped(:include => :geo_viewer).map(&:geo_viewer).each do |gv| 
      scoped_find = gv.filtered_nodes.current_scoped_methods[:find]
      conditions << "(#{GeoViewer.send(:sanitize_sql,scoped_find[:conditions])})" if scoped_find && scoped_find[:conditions]    
    end
    
    conditions.join(' OR ')
  end  
end
