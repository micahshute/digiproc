class Dsp::Systems::System

    attr_accessor :data
    include Convolvable::InstanceMethods, Initializable, FourierTransformable

    def initialize(data)
        @data = data
        initialize_modules(FourierTransformable => {time_data: data})
    end

end