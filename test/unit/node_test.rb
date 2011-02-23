require File.dirname(__FILE__) + '/../test_helper'

class NodeTest < ActiveSupport::TestCase
  
  def setup
    @node = Node.root
  end
  
  def test_should_geo_code_for_location_setter
    assert_nothing_raised do
      @node.location = "Welle, Deventer"
      assert_not_nil @node.lat
      assert_not_nil @node.lng
      assert @node.valid?
    end
  end
  
  def test_should_geo_code_on_update_attribute
    assert_nothing_raised do
      @node.update_attribute :location, "Welle, Deventer"
      assert_not_nil @node.lat
      assert_not_nil @node.lng
      assert @node.valid?
    end
  end
  
  def test_should_retain_existing_value_without_change
    @node.location = "Welle, Deventer"
    location = @node.location
    @node.location = location
    assert_not_nil @node.location
  end
  
  def test_should_be_biased
    @node.location = "Polstraat"
    assert @node.location =~ /Deventer/, :message => "Location expected to be in Deventer, but was #{@node.location} instead"
  end
end