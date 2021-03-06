## Class/Strategy for for encoding a string of bits
# ENCODES SIGNAL PER M-ARY PSK CODING STRATEGY, SEE HW6 ELEG 635
# use the generic DPSK equation for M = 2. We will apply the ORIGINAL signal Dn 
# to the equation βn = (2l−1)π % 2π, l ⩽ M for 
# the phase mapping, and M then the differential signal will be 
# created by saying our transmitted bit will be αn = αn−1 + βn

class Digiproc::Strategies::DifferentialEncodingStrategy

    
    ##
    # Encoding an incoming array of bits into an array of encoded phase angles
    # Requires an input of an array, and has optional arguments of m (number of bits per symbol)
    # And a beginning value (a starting reference phase angle). Outputs an array of 
    # phase angles
    # Unline previous encoding strategies, this does not XOR the bits and then phase shift those 
    # encoded bits. Instead, the bits are transformed into frequencies which are then 
    # added to dealyed versions of themselves modulo 2pi
    def self.encode(arr, m = 2, beginning_val = "0")
        beginning_val = beginning_val.to_s(2) unless beginning_val.is_a? String
        encoded = [beginning_val]
        arr = arr.map(&:to_s)
        for i in 0...arr.length do 
            curr_phase = to_phase(m)[arr[i].to_i(2).to_f]
            last_phase = encoded.last.to_f
            encoded << ((curr_phase + last_phase) % (2 * Math::PI)).to_s
        end
        encoded
    end

    ##
    # Does not simulate a reciever, it just does the inverse algorithm 
    # to retrieve the original message
    # Currently incorrect
    # TODO: fix this method
    def self.decode(bits, m = 2)
        encoded = []  
        for i in 1...bits.length do 
            encoded << ((-1 * bits[i - 1].to_f + bits[i].to_f) % (2 * Math::PI)).to_s
        end
        encoded.map{|phase| decode_phase(m)[phase.to_f]}
    end

    ##
    # Required via the protocol for an encoding strategy, but this
    # algorithm does not require a phase shift so the lambda will return the input
    def self.phase_shift_eqn(m = nil)
        ->(l){ l }
    end

    ##
    # Required via the protocol for an encoding strategy, but this
    # algorithm does not require a phase shift so the lambda will return the input
    def self.phase_to_sym(m = nil)
        ->(l){ l }
    end

    private 
    def self.to_phase(m)
        ->(l){ (((2.0 * (l+1) - 1.0) / m) % 2) * Math::PI }
    end

    def self.decode_phase(m)
        ->(code){ (((code / (Math::PI)) * m) + 1.0) / 2.0 - 1.0 }
    end

    # TODO: IMPLEMENT DECODING STRATEGY PER FIGURE 4-15 in INTRODUCTION TO DIGITAL COMMUNICATIONS, ZIEMER, PETERSON

end