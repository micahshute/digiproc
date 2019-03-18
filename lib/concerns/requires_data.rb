##
# Many modules in this gem require that the class which includes them has a property called `data`. This module can be used by modules which require the use 
# of the `data` property to ensure that they are being used correctly. If `data` is not a property, a `TypeError` will be thrown upon inclusion into the class.
module Dsp::RequiresData
    def self.included(base)
        raise TypeError.new("To implement #{self}, #{base} must have an instance varaible @data, and getters/setters") if not base.method_defined?(:data) 
    end 
end