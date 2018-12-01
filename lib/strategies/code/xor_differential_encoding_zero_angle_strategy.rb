class Dsp::Strategies::XORDifferentialEncodingZeroAngleStrategy

    def self.encode_bits(bits)
        encode_str(bits.to_s(2))
    end

    def self.encode_str(bits)
        bits_arr = bits.split("")
        encoded = ["1"]  
        for i in 0...bits_arr.length do 
            encoded << (encoded.last.to_i(2) ^ bits_arr[i].to_i(2)).to_s
        end
        encoded.join
    end

    def self.encode(arr, m = 2, beginning_val = "1")
        beginning_val = beginning_val.to_s(2) unless beginning_val.is_a? String
        encoded = [beginning_val]
        for i in 0...arr.length do 
            encoded << (encoded.last.to_i(2) ^ arr[i].to_i(2)).to_s(2)
        end
        encoded
    end

    def self.decode_bits(bits)
        dencode_str(bits.to_s(2))
    end

    def self.decode_str(bits)
        bits_arr = bits.split("")
        encoded = []  
        for i in 1...bits_arr.length do 
            encoded << (bits_arr[i - 1].to_i(2) ^ bits_arr[i].to_i(2)).to_s(2)
        end
        encoded.join
    end

    def self.decode(bits)
        encoded = []  
        for i in 1...bits.length do 
            encoded << (bits[i - 1].to_i(2) ^ bits[i].to_i(2)).to_s(2)
        end
        encoded
    end

    def self.phase_shift_eqn(m)
        ->(i){ (2 * Math::PI * (i)) / m }
    end

    def self.phase_to_sym(m)
        ->(phase){ (phase * m / (2.0 * Math::PI))}
    end

end