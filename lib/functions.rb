module Dsp::Functions

    extend Convolvable::ClassMethods
    include Dsp::DataProperties

    def self.cross_correlation(data1, data2)
        self.conv(data1, data2.reverse)
    end

    def self.expand_to(samples, max, min)
        target_center = (max + min) / 2.0
        target__range = max.to_f - min
        smax, smin = samples.max, samples.min
        sample_center = (smax + smin) / 2.0
        sample_range = smax.to_f - smin
        center_map = target_center - sample_center 
        range_map = target_range / sample_range
        mapping = ->(n){ (n + center_map) * range_map }
        process(samples, mapping)
    end

    def self.map_to_eqn(starting_max, starting_min, target_max, target_min)
        target_center = center_of(target_max, target_min)
        target_range = range_of(target_max, target_min)
        starting_center = center_of(starting_max, starting_min) 
        starting_range = range_of(starting_max.to_f, starting_min)
        center_map = target_center - starting_center
        range_map = target_range / starting_range
        ->(n){ (n + center_map) / range_map }
    end

    def self.center_of(max, min)
        (max + min) / 2.0
    end

    def self.range_of(max, min)
        max.to_f - min
    end

end