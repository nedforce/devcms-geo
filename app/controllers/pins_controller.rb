class PinsController < ApplicationController
  
  def highlighted_pin
    image = ::Magick::Image::read(params[:pin]).first
    image = image.composite(Pin::HIGHLIGHT_OVERLAY, ::Magick::NorthEastGravity, ::Magick::OverCompositeOp) if Pin::HIGHLIGHT_OVERLAY
    send_data image.to_blob, :type => 'image/png', :disposition => 'inline'
  end
  
end