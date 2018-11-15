class Dsp::AnalogSignal

    attr_accessor :sample_rate, :size, :companding_strategy, :signal, :quantization_bits, :quant_max, :quant_min
    attr_reader :raw_samples, :quantized_samples, :eqn
    def initialize(eqn: ,sample_rate: 0.0001, size: 100, companding_strategy: nil, quantization_bits: Float::INFINITY, quant_max: nil, quant_min: nil)
        @eqn, @sample_rate, @size, @quantization_bits, @quant_max, @quant_min = eqn, sample_rate, size, quantization_bits, quant_max, quant_min
        @signal = eqn
        @companding_strategy = (companding_strategy.is_a?(Class) and !!companding_strategy) ? companding_strategy.new : companding_strategy 
    end

    def digitize
        samples = sample
        @raw_samples = samples
        samples = compress(samples) if not companding_strategy.nil?
        samples = quantize(samples, self.quantization_bits, self.quant_max, self.quant_min) if self.quantization_bits < Float::INFINITY
        samples = expand(samples) if not companding_strategy.nil?
        @quantized_samples = samples
        samples
    end

    def to_ds
        DigitalSignal.new(data: digitize)
    end

    def normalized_quantization_rms_error
        total = 0
        x_max = self.raw_samples.max
        self.raw_samples.each_with_index do |x, i|
            total += ((x.to_f - quantized_samples[i]) / x_max) ** 2
        end
        (1.0 / size) * (total ** (0.5))
    end

    private

    def quantize(samples, bits, max, min)
        sample_bits = quantize_bit_reprisentation(samples, bits, max, min)
        process(sample_bits, map_to_eqn(bits**2 / 2.0 , -(bits**2) / 2.0 , max, min))
    end

    def quantize_positive_bits(samples, bits, max, min)
        levels = bits ** 2
        quantize_bit_reprisentation(samples, bits, max, min) + (levels / 2.0)
    end

    def quantize_bit_reprisentation(samples, bits, max, min)
        max = samples.max if max.nil? 
        min = samples.min if min.nil?
        levels = bits ** 2
        mapped = map_to_unit_centered(samples, max, min)
        process(mapped, ->(n){ (n * levels / 2.0).round})
    end

    def compress(samples)
        self.companding_strategy.compress(samples)
    end

    def expand(samples)
        self.companding_strategy.expand(samples)
    end

    def sample
        sample_times = process(0...size, ->(n){ n * self.sample_rate })
        process(sample_times, self.signal)
    end

    def process(inputs , equation)
        inputs.map{ |n| equation.call(n) }
    end

    def map_to_unit_centered(samples, max, min)
        center = center_of(max, min)
        range = range_of(max, min)
        a_range = range / 2.0
        mapping = ->(n){ (n - center) / a_range }
        process(samples, mapping)
    end

    def map_to_eqn(starting_max, starting_min, target_max, target_min)
        target_center = center_of(target_max, target_min)
        target_range = range_of(target_max, target_min)
        starting_center = center_of(starting_max, starting_min) 
        starting_range = range_of(starting_max.to_f, starting_min)
        center_map = target_center - starting_center
        range_map = target_range / starting_range
        ->(n){ (n - starting_center) * range_map + target_center}
    end

    def center_of(max, min)
        (max + min) / 2.0
    end

    def range_of(max, min)
        max.to_f - min
    end

end