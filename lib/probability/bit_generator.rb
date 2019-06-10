##
# Create random bit for testing purposes
#
class Digiproc::Probability::RandomBitGenerator

    ##
    # Returns a string representing a bitstream
    # == Arguments
    # size:: [Integer] number of desired bits
    # p_0:: [Float] (between 0 and 1) probability of a bit 0 occurring (default value: 0.5)
    # p_1:: [Float] (between 0 and 1) probability of a bit 1 occurring (default value: 0.5)
    # random_generator:: Any random generator that follows the prototype of ruby's `Random` class. Defaults to `Random.new`
    #
    ## bitgen = Digiproc::Probability::RandomBitGenerator
    ## bitgen.bitstream(size: 10) # => "1000010010"
    def self.bitstream(size: , p_0: 0.5, p_1: 0.5, random_generator: Random.new)
        stream = ''
        size.times do 
            stream += get_bit(p_0: p_0, p_1: p_1, random_generator: random_generator).to_s
        end
        stream
    end

    ##
    # Returns an Integer
    # == Arguments
    # p_0:: [Float] (between 0 and 1) probability of a bit 0 occurring (default value: 0.5)
    # p_1:: [Float] (between 0 and 1) probability of a bit 1 occurring (default value: 0.5)
    # random_generator:: Any random generator that follows the prototype of ruby's `Random` class. Defaults to `Random.new`
    #
    ## bitgen.bitstream # => 1
    def self.get_bit(p_0: 0.5, p_1: 0.5, random_generator: Random.new)
        raise ArgumentError.new("Probabilities must add up to 1") if p_0 + p_1 != 1
        rnum = 1 - random_generator.rand
        return 0 if rnum <= p_0 
        return 1
    end

    ##
    # Constructor for bitstream
    # == Arguments
    # p_0:: [Float] between 0 and 1: probability of a 0 bit (defaults to 0.5)
    # p_1:: [Float] between 0 and 1: probability of a 1 bit (defaults to 0.5)
    ## bitstream = bitgen.new_bitstream
    def self.new_bitstream(p_0: 0.5 , p_1: 0.5)
        self.new(bits_per_symbol: 1, p_0: p_0, p_1: p_1)
    end

    ##
    # Constructor for symbol_stream
    # == Arguments
    # bits_per_symbol:: [Integer] set the number of bits for each symbol
    # p_0:: [Float] between 0 and 1: probability of a 0 bit (defaults to 0.5)
    # p_1:: [Float] between 0 and 1: probability of a 1 bit (defaults to 0.5)
    ## bitstream = bitgen.new_bitstream
    def self.new_symbol_stream(bits_per_symbol: , p_0: 0.5, p_1: 0.5)
        self.new(bits_per_symbol: bits_per_symbol, p_0: p_0, p_1: p_1) 
    end

    attr_accessor :bits_per_symbol, :p_0, :p_1, :random_generator

    ##
    # == Arguments
    # # bits_per_symbol:: [Integer] set the number of bits for each symbol
    # p_0:: [Float] between 0 and 1: probability of a 0 bit (defaults to 0.5)
    # p_1:: [Float] between 0 and 1: probability of a 1 bit (defaults to 0.5)
    #
    ## bitstream = bitgen.new(bits_per_symbol: 1) => same as bitgen.new_bitstream
    def initialize(bits_per_symbol: , p_0: 0.5, p_1: 0.5 )
        raise ArgumentError.new("Probabilities of bits must add up to 1") if p_0 + p_1 != 1
        @bits_per_symbol, @p_0, @p_1, @random_generator = bits_per_symbol, p_0, p_1, Random.new
    end

    ##
    # == Arguments
    # size:: [Integer] number of symbols to be generated (or bits if self.bits_per_symbol is 1)
    ## bistream = Digiproc::Probability::RandomBitGenerator.new_bitstream
    ## symstream = Digiproc::Probability::RandomBitGenerator.new_symbol_stream(bits_per_symbol: 8)
    ## bitstream.generate(10) # => "0001110010"
    ## symstream.generate(4) # => ["10100111", "00111100", "00111010", "10000100"]
    def generate(size)
        if self.bits_per_symbol == 1
            return self.class.bitstream(size: size, p_0: @p_0, p_1: @p_1, random_generator: @random_generator)
        else
            signal = []
            size.times do 
                signal << self.class.bitstream(size: @bits_per_symbol, p_0: @p_0, p_1: @p_1, random_generator: @random_generator)
            end
            return signal
        end
    end
    
    
end