class Dsp::Systems::System

    attr_accessor :data
    include Convolvable::InstanceMethods, Initializable, FourierTransformable

    def initialize(data)
        @data = data
        initialize_modules(FourierTransformable => {time_data: data})
    end

    def to_ds
        DigitalSignal.new(data: self.data)
    end

    def to_a
        self.data
    end

end