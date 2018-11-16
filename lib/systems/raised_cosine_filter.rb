class Dsp::Systems::RaisedCosineFilter < Dsp::Systems::System


    def initialize(tb: ,beta: ,sample_rate: ,size: )
        @eqn = ->(t, tb, beta){ (tb / (2 * beta.to_f) or (-tb / (2 * beta.to_f))) ? Math::PI * Dsp::Functions.sinc(1.0 / (2 * beta)) / (4.0 * tb) : (1 / tb.to_f) * Dsp::Functions.sinc(t / tb.to_f) * Math.cos((Math::PI * beta * t) / tb.to_f) / (1 - ((2*beta*t) / tb.to_f) ** 2)}
        # super(eqn: @eqn, sample_rate: sample_rate, size: size)
        data = Dsp::AnalogSignal.new(eqn: @eqn, sample_rate: sample_rate, size: size).digitize
        super(data)
    end

end