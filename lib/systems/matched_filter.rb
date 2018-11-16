class Dsp::Systems::MatchedFilter < Dsp::Systems::System

    def initilize(eqn: , sample_rate: , size: )
        data = Dsp::AnalogSignal.new(eqn: eqn, sample_rate: sample_rate, size: size).digitize
        super(data)
    end
end