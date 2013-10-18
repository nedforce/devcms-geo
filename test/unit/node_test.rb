require File.expand_path('../../test_helper.rb', __FILE__)

class NodeTest < ActiveSupport::TestCase

  def setup
    @node = Node.root
  end

  def test_should_geo_code_on_create
    node = Section.create(:title => 'test', :parent => Node.root, :location => 'Polstraat 1, Deventer').node
    assert node.location =~ /Deventer/
  end

  def test_should_geo_code_for_location_setter
    assert_nothing_raised do
      @node.location = 'Welle, Deventer'
      @node.save!
      assert_not_nil @node.lat
      assert_not_nil @node.lng
      assert @node.valid?
    end
  end

  def test_should_set_coordinates_if_present
    assert_nothing_raised do
      @node.update_attributes :location_coordinates => '52.22945332,6.20216252'
      assert_not_nil @node.lat
      assert_not_nil @node.lng
      assert @node.valid?
    end
  end

  def test_should_geo_code_on_update_attributes
    assert_nothing_raised do
      @node.update_attributes :location => 'Welle, Deventer'
      assert_not_nil @node.lat
      assert_not_nil @node.lng
      assert @node.valid?
    end
  end

  def test_should_retain_existing_value_without_change
    @node.location = 'Welle, Deventer'
    location       = @node.location
    @node.location = location
    assert_not_nil @node.location
  end

  def test_should_ignore_rate_limit
    Node.stubs(:try_geocode).returns(nil)
    assert_nothing_raised do
      @node.update_attributes :location => 'Polstraat, Deventer'
      assert_nil @node.lat
      assert_nil @node.lng
      assert @node.valid?, @node.errors.full_messages.join(' ')
    end
  end

  def test_should_not_allow_invalid_locations
    Node.unstub(:try_geocode)
    assert_nothing_raised do
      assert_nil @node.lat
      assert_nil @node.lng
      @node.update_attributes :location => 'Dit adres bestaat dus echt niet, 1235XX, De stad'
      assert_nil @node.lat
      assert_nil @node.lng
      assert !@node.valid?
    end
  end

  def test_should_be_biased
    @node.location = 'Polstraat'
    @node.save!
    
    assert @node.location =~ /Deventer/, "Location expected to be in Deventer, but was #{@node.location} instead"
  end
  
  def test_should_inherit_pins
    node = Section.create(:title => 'test', :parent => Node.root, :location => 'Polstraat 1, Deventer').node
        
    pin1 = Pin.create(:title => 'Pin 1', :file => File.open(File.dirname(__FILE__) + '/../fixtures/files/pin.png'))
    pin2 = Pin.create(:title => 'Pin 2', :file => File.open(File.dirname(__FILE__) + '/../fixtures/files/pin.png'))

    assert_nil node.own_or_inherited_pin        
    assert node.root.update_attributes(:pin => pin1)
    assert node.update_attributes(:pin => pin2)
    
    assert_equal pin2, node.own_or_inherited_pin
    
    assert node.update_attributes(:pin => nil)
    assert_equal pin1, Node.find(node.id).own_or_inherited_pin    
  end

end
