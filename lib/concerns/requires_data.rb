module RequiresData
    def self.included(base)
        raise TypeError.new("To implement #{self}, #{base} must have an instance varaible @data, and getters/setters") if not base.method_defined?(:data) 
    end 
end