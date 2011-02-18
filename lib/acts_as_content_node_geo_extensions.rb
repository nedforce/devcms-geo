module Acts #:nodoc:
  module ContentNode #:nodoc:
    module GeoExtensions
      def self.included(base)
        base.extend(ClassMethods)
      end
    
      module ClassMethods
        def acts_as_content_node(*args)
          super
          delegate :location, :location=, :to => :node, :allow_nil => true
        end
      end
    end
  end
end