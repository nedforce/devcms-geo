# This model represents a self referential join model between geo viewers to support creation of geo viewers 
# that represents other geo viewers
#
# Attributes
#
# * +combined_geo_viewer_id+ - The ID of the combined geo viewer.
# * +eo_viewer_id+ - The ID of the geo viewer.
# * +toggled+ - Boolean that sets whether the layer should be toggled on the combined viewer by default
# * +toggable+ -  Boolean that sets whether the layer can be turned on/off by a user
class GeoViewerPlacement < ActiveRecord::Base
  belongs_to :combined_geo_viewer, :class_name => 'GeoViewer'
  belongs_to :geo_viewer
  
  scope :toggled, :conditions => { :is_toggled => true }  
  scope :toggable, :conditions => { :is_toggable => true }
  
  delegate :title, :to => :geo_viewer
  
  def _destroy
    !new_record?
  end
end
