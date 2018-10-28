class DigitalSignal
    attr_accessor :data
    include Convolvable::InstanceMethods, Initializable, FourierTransformable

    
    def self.new_from_eqn(eqn: , size: )
        rng = (0...size)
        self.new(data: rng.map{ |n| eqn.call(n) })
    end

    def self.new_from_equations(eqns: , ranges: )
        data = []
        eqns.each_with_index do |eqn, i|
            ranges[i].each do |n|
                data[n] = eqn.call(n)
            end
        end
        data.map!{ |val| val.nil? ? 0 : val }
        self.new(data: data)
    end
    
    
    def initialize(data: )
        raise ArgumentError.new("Data must be an Array, not a #{data.class}") if not data.is_a? Array
        @data = data
        initialize_modules(FourierTransformable => {data: data})
    end

    def i(*n)
        case n.length
        when 1
            return value_at(n.first)
        when 2
            return values_between(n.first, n.last)
        else
            return n.map{ |val| data[val] }
        end
    end

    def value_at(n)
        data[n].nil? ? 0 : data[n]
    end

    def values_between(start,stop)
        data[start, stop - start + 1]
    end

    def ds_conv(signal)
        DigitalSignal.new(data: self.conv(signal))
    end

end