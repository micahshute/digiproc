##
# Including Class instance must have a data property which is an array. Allows you to say 
# classInstance1 * classInstance2 and the two data vectors will be multiplied on an element-by-element basis
# Note: the data vectors must be the same length

module Digiproc::Multipliable

    def self.included(base)
        base.class_eval do 
            include RequiresData
        end
    end


    ##
    # Multiplies the instance's `data` property on an element-by-element basis with the other instance's data property
    def * (obj)
        raise ArgumentError.new("Object must have #data reader") if not obj.respond_to?(:data)
        raise ArgumentError.new("Object data must respond to #times, #{obj.data.class} does not") if not obj.data.respond_to?(:times)
        self.data.times obj.data
    end
end