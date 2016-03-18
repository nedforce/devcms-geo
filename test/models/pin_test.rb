require File.expand_path('../../test_helper.rb', __FILE__)

class PinTest < ActiveSupport::TestCase
  setup do
    @pin = create_pin
  end

  test 'should create pin' do
    assert @pin.valid?
    assert !@pin.new_record?
  end

  test 'should return image geometry' do
    pin_geometry = @pin.geometry
    assert_equal 32, pin_geometry.first
    assert_equal 37, pin_geometry.last
  end

  protected

  def create_pin(options = {})
    Pin.create({
      title: 'Pin 1',
      file: File.open(File.dirname(__FILE__) + '/../fixtures/files/pin.png')
    }.merge(options))
  end
end
