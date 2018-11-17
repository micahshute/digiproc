class Dsp::Systems::MatchedFilter < Dsp::Systems::System

    def new_from_analog_signal(signal)
        self.new(signal_data: signal.digitize)
    end

    def new_from_digital_signal(signal)
        self.new(signal_data: signal.data)
    end

    def initialize(signal_eqn: nil, sample_rate: nil, size: nil, signal_data: nil)
        raise ArgumentError.new("Must have signal_eqn, sample_rate, and size XOR signal_data") if (signal_eqn.nil? or sample_rate.nil? or size.nil?) and (signal_data.nil?)
        if signal_data.nil?
            data = Dsp::AnalogSignal.new(eqn: signal_eqn, sample_rate: sample_rate, size: size).digitize.map(:&conjugate).reverse
            super(data)
        else
            data = signal_data.map(&:conjugate).reverse
            super(data)
        end
    end
end