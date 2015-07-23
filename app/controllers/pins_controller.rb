class PinsController < ApplicationController
  def highlighted_pin
    image = ::Magick::Image::read(params[:pin]).first
    if Pin::HIGHLIGHT_OVERLAY
      image = image.composite(Pin::HIGHLIGHT_OVERLAY, ::Magick::NorthEastGravity, ::Magick::OverCompositeOp)
    end

    send_data image.to_blob, type: 'image/png', disposition: 'inline'
  end
end
