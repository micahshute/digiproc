class Dsp::Systems::MatchedFilter < Dsp::Systems::System

    def initilize(signal_eqn: , sample_rate: , size: )
        data = Dsp::AnalogSignal.new(eqn: signal_eqn, sample_rate: sample_rate, size: size).digitize.reverse
        super(data)
    end
end