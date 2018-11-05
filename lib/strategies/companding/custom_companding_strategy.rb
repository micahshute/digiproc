class CustomCompandingStrategy

    attr_accessor :eqn, :inverse

    def initialize(eqn, inverse)
        @eqn, @inverse = eqn, inverse
    end 

    def process(data, fn)
        data.map{ |n| fn.call(n) }
    end

    def compress(data)
        self.process(data, eqn)
    end

    def expand(data)
        self.process(data, inverse)
    end

end