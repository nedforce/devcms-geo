# This model is used to represent a pin that can be places on a map. 
#
# *Specification*
#
# Attributes
#
# * +title+ - The title of the geo viewer.
# * +file+ - A pin file
#
# Preconditions
#
# * Requires the presence of +title+, +file+.
class Pin < ActiveRecord::Base
  
  has_many :nodes, :dependent => :nullify

  mount_uploader :file, PinUploader
  
  validates_presence_of :title, :file
  
  def geometry
    if file
      @geometry ||= begin
        img = ::Magick::Image::read(file.path).first
        [ img.columns, img.rows ]
      end
    end 
    
    @geometry   
  end

end
