class Dsp::Systems::System

    attr_accessor :data
    include Dsp::Convolvable::InstanceMethods, Dsp::Initializable, Dsp::FourierTransformable

    def initialize(data)
        @data = data
        initialize_modules(Dsp::FourierTransformable => {time_data: data})
    end

    def to_ds
        Dsp::DigitalSignal.new(data: self.data)
    end

    def to_a
        self.data
    end

end