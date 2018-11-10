class Dsp::Systems::System

    attr_accessor :data
    include Convolvable::InstanceMethods, Initializable, FourierTransformable


end