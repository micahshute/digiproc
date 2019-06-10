##
# Class for performing actions upon an Analog, Continuous Time signal defined by an equation
# Initialized with a lambda or proc, the signal is sampled, companded, quantized, and can be turned into a `Digiproc::DigitalSignal`
class Digiproc::AnalogSignal

    attr_accessor :sample_rate, :size, :companding_strategy, :signal, :quantization_bits, :quant_max, :quant_min
    attr_reader :raw_samples, :quantized_samples, :eqn

    ##
    # See examples/analog_signals/companding for full options in initializer
    ## fn = ->(x){ Math.sin(x) }
    ## asig = Digiproc::AnalogSignal.new(eqn: fn) 
    def initialize(eqn: ,sample_rate: 0.0001, size: 100, companding_strategy: nil, quantization_bits: Float::INFINITY, quant_max: nil, quant_min: nil)
        @eqn, @sample_rate, @size, @quantization_bits, @quant_max, @quant_min = eqn, sample_rate, size, quantization_bits, quant_max, quant_min
        @signal = eqn
        @companding_strategy = (companding_strategy.is_a?(Class) and !!companding_strategy) ? companding_strategy.new : companding_strategy 
    end

    ##
    # No arguments, outputs [Array] digital samples
    # Will sample, compand (compress, expand), and quantize samples (companding and quantizing optional)
    # See analog_signals examples
    def digitize
        samples = sample
        @raw_samples = samples
        samples = compress(samples) if not companding_strategy.nil?
        samples = quantize(samples, self.quantization_bits, self.quant_max, self.quant_min) if self.quantization_bits < Float::INFINITY
        samples = expand(samples) if not companding_strategy.nil?
        @quantized_samples = samples
        samples
    end

    ##
    # Returns a Digiproc::DigitalSignal of the digital signals
    def to_ds
        Digiproc::DigitalSignal.new(data: digitize)
    end

    ##
    # Returns [Float] normalized quantization RMS error. See examples/analog_signal/companding
    def normalized_quantization_rms_error
        total = 0
        x_max = self.raw_samples.max
        self.raw_samples.each_with_index do |x, i|
            total += ((x.to_f - quantized_samples[i]) / x_max) ** 2
        end
        (1.0 / size) * (total ** (0.5))
    end

    private

    ##
    # Quantize signals to a certain number of bits over a specified range
    # == Args
    # samples:: [Array] input data
    # bits:: [Integer] number of bits used to reprisent each sample
    # max:: maximum possible sample values (to be reprisented by max bits in quantization)
    # min:: minimum possible sample value (to be reprisented by minimum bits value in quantization)
    # bit quantization is mapped back to original max and min values, returning what they would look like upon
    # attempted reconstruction of the analog signal.
    def quantize(samples, bits, max, min)
        sample_bits = quantize_bit_reprisentation(samples, bits, max, min)
        process(sample_bits, map_to_eqn(bits**2 / 2.0 , -(bits**2) / 2.0 , max, min))
    end


    def quantize_positive_bits(samples, bits, max, min)
        levels = bits ** 2
        quantize_bit_reprisentation(samples, bits, max, min) + (levels / 2.0)
    end

    ## 
    # Based off max and min (defined by samples.max and samples.min if not provided), the samples are mapped from -1 to 1.
    # Then they are multiplied by the number of "levels" of quantization (ie: number_of_bits ^ 2 / 2). 
    # Then, the samples are rounded, thus quantizing the samples to the number of bits
    def quantize_bit_reprisentation(samples, bits, max, min)
        max = samples.max if max.nil? 
        min = samples.min if min.nil?
        levels = bits ** 2
        mapped = map_to_unit_centered(samples, max, min)
        process(mapped, ->(n){ (n * levels / 2.0).round})
    end

    ##
    # Compress samples for companding before quantization
    def compress(samples)
        self.companding_strategy.compress(samples)
    end

    ##
    # Expand samples for companding after quantization
    def expand(samples)
        self.companding_strategy.expand(samples)
    end

    ##
    # Sample the signal and return [Array] of sampled values
    def sample
        sample_times = process(0...size, ->(n){ n * self.sample_rate })
        process(sample_times, self.signal)
    end

    ##
    # Helper for processing an array of values with a lambda function
    def process(inputs , equation)
        inputs.map{ |n| equation.call(n) }
    end

    ##
    # Map values to range -1 to 1
    def map_to_unit_centered(samples, max, min)
        center = center_of(max, min)
        range = range_of(max, min)
        a_range = range / 2.0
        mapping = ->(n){ (n - center) / a_range }
        process(samples, mapping)
    end

    ##
    # Return a lambda function which will map a dataset to a target maximum and minimum
    def map_to_eqn(starting_max, starting_min, target_max, target_min)
        target_center = center_of(target_max, target_min)
        target_range = range_of(target_max, target_min)
        starting_center = center_of(starting_max, starting_min) 
        starting_range = range_of(starting_max.to_f, starting_min)
        center_map = target_center - starting_center
        range_map = target_range / starting_range
        ->(n){ (n - starting_center) * range_map + target_center}
    end

    ##
    # Return center [Float]
    def center_of(max, min)
        (max + min) / 2.0
    end

    ##
    # Return range [Float]
    def range_of(max, min)
        max.to_f - min
    end

end