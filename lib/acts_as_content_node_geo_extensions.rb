module Acts #:nodoc:
  module ContentNode #:nodoc:
    module GeoExtensions
      def self.included(base)
        base.extend(ClassMethods)
      end
    
      module ClassMethods
        def acts_as_content_node(*args)
          super
          delegate :location, :to => :node, :allow_nil => true
          
          attr_writer :location
          
          self.class_eval do
            def set_virtual_node_attributes_with_location(node)
              node.location = @location
              set_virtual_node_attributes_without_location(node)
            end
            
            alias_method_chain :set_virtual_node_attributes, :location
            
          end
        end
      end
    end
  end
end