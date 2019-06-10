##
# A class which allows a custom companding strategy to be used via a lambda function 
# inputted into the initilizer. 

class Digiproc::Strategies::CustomCompandingStrategy

    attr_accessor :eqn, :inverse

    # initialize wiht a companding equation (via a proc or lambda) as well as the inverse equation
    def initialize(eqn, inverse)
        @eqn, @inverse = eqn, inverse
    end 

    # maps an array (first argument) with a lambda (second argument)
    def process(data, fn)
        data.map{ |n| fn.call(n) }
    end

    # use the compression companding lambda (or proc) to compress an array of numerics
    def compress(data)
        self.process(data, eqn)
    end

    # Use the inverse labda (or proc) to decompress an array of numerics
    def expand(data)
        self.process(data, inverse)
    end

end