class Dsp::Probability::RealizedGaussianDistribution

    attr_accessor :mean, :stddev, :generator, :data
    attr_reader :size

    include Convolvable::InstanceMethods, Initializable, FourierTransformable

    def initialize(mean: , stddev: , size: ,generator: Dsp::Strategies::GaussianGeneratorBoxMullerStrategy.new)
        @mean, @stddev, @generator, @size = mean, stddev, generator, size
        generator.mean = mean
        generator.stddev = stddev
        data = []
        size.times do 
            data << generator.rand
        end
        @data = data
        initialize_modules(FourierTransformable => {time_data: data})
    end

end