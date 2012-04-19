require File.dirname(__FILE__) + '/../test_helper'

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
    assert node.root.update_attribute(:pin, pin1)
    assert node.update_attribute(:pin, pin2)
    
    assert_equal pin2, node.own_or_inherited_pin
    
    assert node.update_attribute(:pin, nil)
    assert_equal pin1, node.reload.own_or_inherited_pin    
  end

end
