class Dsp::Systems::CustomSystems < Dsp::Systems::System

    def initialize(eqn: , size: , sample_rate: , data: )
        raise ArgumentError.new("Must have signal_eqn, sample_rate, and size XOR data") if (signal_eqn.nil? or sample_rate.nil? or size.nil?) and (data.nil?)
        if data.nil?
            data = Dsp::AnalogSignal.new(eqn: signal_eqn, sample_rate: sample_rate, size: size).digitize.map(:&conjugate).reverse
            super(data)
        else
            super(data)
        end
    end

end