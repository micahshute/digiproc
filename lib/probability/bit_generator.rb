class Dsp::Probability::RandomBitGenerator

    def self.bitstream(size: , p_0: 0.5, p_1: 0.5, random_generator: Random.new)
        stream = ''
        size.times do 
            stream += get_bit(p_0: p_0, p_1: p_1, random_generator: random_generator).to_s
        end
        stream
    end

    def self.get_bit(p_0: 0.5, p_1: 0.5, random_generator: Random.new)
        raise ArgumentError.new("Probabilities must add up to 1") if p_0 + p_1 != 1
        rnum = 1 - random_generator.rand
        return 0 if rnum <= p_0 
        return 1
    end

    def self.new_bitstream(p_0: 0.5 , p_1: 0.5)
        self.new(bits_per_symbol: 1, p_0: p_0, p_1: p_1)
    end

    def self.new_symbol_stream(bits_per_symbol: , p_0: 0.5, p_1: 0.5)
        self.new(bits_per_symbol: bits_per_symbol, p_0: p_0, p_1: p_1) 
    end

    attr_accessor :bits_per_symbol, :p_0, :p_1, :random_generator

    def initialize(bits_per_symbol: , p_0: 0.5, p_1: 0.5 )
        raise ArgumentError.new("Probabilities of bits must add up to 1") if p_0 + p_1 != 1
        @bits_per_symbol, @p_0, @p_1, @random_generator = bits_per_symbol, p_0, p_1, Random.new
    end

    
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