module Dsp::Multipliable

    def self.included(base)
        base.class_eval do 
            include RequiresData
        end
    end


    def * (obj)
        raise ArgumentError.new("Object must have #data reader") if not obj.respond_to?(:data)
        raise ArgumentError.new("Object data must respond to #times, #{obj.data.class} does not") if not obj.data.respond_to?(:times)
        self.data.times obj.data
    end
end