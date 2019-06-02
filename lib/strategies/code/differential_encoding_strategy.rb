## Class for 

class Dsp::Strategies::DifferentialEncodingStrategy

    # ENCODES SIGNAL PER M-ARY PSK CODING STRATEGY, SEE HW6 ELEG 635

    def self.encode(arr, m = 2, beginning_val = "0")
        beginning_val = beginning_val.to_s(2) unless beginning_val.is_a? String
        encoded = [beginning_val]
        for i in 0...arr.length do 
            curr_phase = to_phase(m)[arr[i].to_i(2).to_f]
            last_phase = encoded.last.to_f
            encoded << ((curr_phase + last_phase) % (2 * Math::PI)).to_s
        end
        encoded
    end

    def self.decode(bits, m = 2)
        encoded = []  
        for i in 1...bits.length do 
            encoded << ((-1 * bits[i - 1].to_f + bits[i].to_f) % (2 * Math::PI)).to_s
        end
        encoded.map{|phase| decode_phase(m)[phase.to_f]}
    end

    def self.phase_shift_eqn(m = nil)
        ->(l){ l }
    end

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