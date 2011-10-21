module Acts #:nodoc:
  module ContentNode #:nodoc:
    module GeoExtensions
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_content_node(*args)
          super
          
          delegate_accessor :location, :to => :node
        end
      end
    end
  end
end
