##
# Class to create a sample of Gaussian Distributed values
class Dsp::Probability::GaussianDistribution

    attr_accessor :mean, :stddev, :generator, :data
    attr_reader :size

    include Dsp::Convolvable::InstanceMethods, Dsp::Initializable, Dsp::FourierTransformable

    ##
    # == Initialize arguments
    # mean:: [Float] mean of the population
    # stddev:: [Float] standard deviation of the population
    # size:: [Integer] number of datapoints
    # generator:: Strategy for making Gaussian values. Defaults to Dsp::Strategies::GaussianGeneratorBoxMullerStrategy.new
    def initialize(mean: , stddev: , size: ,generator: Dsp::Strategies::GaussianGeneratorBoxMullerStrategy.new)
        @mean, @stddev, @generator, @size = mean, stddev, generator, size
        generator.mean = mean
        generator.stddev = stddev
        data = []
        size.times do 
            data << generator.rand
        end
        @data = data
        initialize_modules(Dsp::FourierTransformable => {time_data: data})
    end


end