##
# Class used as a strategy for differentially encoding a bitstream 
# by XORing it with a time-delayed version of itself:
# Differentially encode the binary stream using the XOR operator, 
# and then map the binary stream using the equation 
# βn = 2π(i−1) , i = 1..M which gives you a mapping of 0 => 0, 1 => π
# The Differentially Encoded Signal => Cn = Dn ⨁ Cn−1
# is the signal mapped to phase as described above.
# The XOR operation in seeded with a 1

class Dsp::Strategies::XORDifferentialEncodingZeroAngleStrategy

    ##
    # Accept an int reprisenting a bit stream. Encode the
    # bits by XORing it with a time delay of itself via
    # the `self.encode_str` method below. The first bit is seeded 
    # with a "1"
    def self.encode_bits(bits)
        encode_str(bits.to_s(2))
    end


    ##
    # Input a string of bits
    # Outupt the XOR'd version of the bits, seeded with a beginning "1"
    def self.encode_str(bits)
        bits_arr = bits.split("")
        encoded = ["1"]  
        for i in 0...bits_arr.length do 
            encoded << (encoded.last.to_i(2) ^ bits_arr[i].to_i(2)).to_s
        end
        encoded.join
    end

    ##
    # Encoding an incoming array of bits (as strings) into an array of XOR'd bits
    # Requires an input of an array, and has optional arguments of m (number of bits per symbol)
    # And a beginning value (a starting reference phase angle). Outputs an array of 
    # XOR'd bits
    def self.encode(arr, m = 2, beginning_val = "1")
        beginning_val = beginning_val.to_s(2) unless beginning_val.is_a? String
        encoded = [beginning_val]
        for i in 0...arr.length do 
            encoded << (encoded.last.to_i(2) ^ arr[i].to_i(2)).to_s(2)
        end
        encoded
    end


    ##
    # Input is an integer
    # The method calls the `decode_str` method below and inputs
    # a string of the binary of the input integer.
    # The output will be the original bitstream encoded by this encoding strategy
    # in string form
    def self.decode_bits(bits)
        dencode_str(bits.to_s(2))
    end


    ##
    # Input an encoded binary bit stream in string form
    # Output a string of the original bitstream 
    def self.decode_str(bits)
        bits_arr = bits.split("")
        encoded = []  
        for i in 1...bits_arr.length do 
            encoded << (bits_arr[i - 1].to_i(2) ^ bits_arr[i].to_i(2)).to_s(2)
        end
        encoded.join
    end


    ##
    # Input an array of encoded bits (as strings)
    # Output an array of decoded bits
    def self.decode(bits)
        encoded = []  
        for i in 1...bits.length do 
            encoded << (bits[i - 1].to_i.to_s.to_i(2) ^ bits[i].to_i.to_s.to_i(2)).to_s(2)
        end
        encoded
    end

     ##
    # Return a lambda which transforms a bit into a phase 
    # Input an integer specifying the number of bits in a symbol
    # Input to the returned lambda should be the symbol value in decimal form
    # Ouptut of the lambda is the encoded phase angle
    def self.phase_shift_eqn(m)
        ->(i){ (2 * Math::PI * (i)) / m }
    end

    ##
    # Return a lambda which transforms a pahse into a symbol
    # Input an integer specifying the number of bits in a symbol
    # Input to the returned lambda is the encoded phase angle
    # Output of the lambda is the binary symbol
    def self.phase_to_sym(m)
        ->(phase){ (phase * m / (2.0 * Math::PI))}
    end

end