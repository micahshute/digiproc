class Dsp::Strategies::PSK

    attr_accessor :m, :modulating_signal , :carrier_signal_eqn, :coding_strategy, :phase_shift_eqn, :signal_to_phase, :coded_signal, :phase_signal, :carrier_frequency, :pulse_length

    #modulating_signal takes an array; each element is a symbol
    def initialize(m: 2 ,carrier_signal_eqn: ->(a, fo, t, theta){ a * Math.cos(2*Math::PI * fo * t + theta) }, modulating_signal: ,coding_strategy: Dsp::Strategies::XORDifferentialEncodingStrategy, carrier_frequency: 10000, pulse_length: 0.00015)
        @m, @carrier_signal_eqn, @modulating_signal, @coding_strategy, @carrier_frequency, @pulse_length = m, carrier_signal_eqn, modulating_signal, coding_strategy, carrier_frequency, pulse_length
        if coding_strategy.nil?
            @phase_shift_eqn = ->(i){ (2 * Math::PI * (i)) / m }
            @coded_signal = @modulating_signal
        else
            @phase_shift_eqn = coding_strategy.phase_shift_eqn(m)
            @coded_signal = coding_strategy.encode modulating_signal, 2, "0"
        end
        @signal_to_phase = {}
        for i in 0...m do
            @signal_to_phase[i.to_s] = @phase_shift_eqn[i]
        end

        @phase_signal = @coded_signal.map{ |coded_symbol| @phase_shift_eqn[coded_symbol.to_f] }

    end

    def output(a: 1)
        eqn = Proc.new do |t|
            theta_index = (t.to_f / @pulse_length.to_f).floor
            # puts "t: #{t}, pulse length: #{@pulse_length}, div: #{t.to_f / @pulse_length}"
            @carrier_signal_eqn[a, @carrier_frequency, t, @phase_signal[theta_index]]
        end
        sample_rate = 0.01 / @carrier_frequency
        size = @pulse_length.to_f * @phase_signal.length / sample_rate
        Dsp::AnalogSignal.new(eqn: eqn, sample_rate: sample_rate, size: size)
    end 

    def decode
        eqn = coding_strategy.nil? ? decode_eqn : coding_strategy.phase_to_sym(m)
        sym = @phase_signal.map{ |phase| eqn[phase] }
        sym = coding_strategy.decode(sym) if not coding_strategy.nil?
        return sym
    end

    def reciever_decode
        recieved = output.to_ds.fft.magnitude
        ts = 1 / (@carrier_frequency / 0.01)
        max_freq = 1.0 / ts
        normalized_target = @carrier_frequency / max_freq.to_f
        bw = (0.57 / ts) / max_freq.to_f
        plt = Dsp::QuickPlot
        factory = Dsp::Factories::FilterFactory
        bpf = factory.filter_for(type: "bandpass", wo: normalized_target * Math::PI * 2, bw: bw * Math::PI * 2, transition_width: 0.0001, stopband_attenuation: 80)
        bpf.fft.calculate_at_size(2 ** 16)

        filtered = (bpf.fft * output.to_ds.fft(2** 16)).ifft.map(&:real)
        sample_interval = @pulse_length / (0.01 / @carrier_frequency)
        output = []
        for i in (sample_interval + 1).to_i...filtered.length do 
            output << (filtered[i] * filtered[i-sample_interval]) 
        end
        lpf = factory.filter_for(type: "lowpass", wc: 2 * Math::PI / 4, transition_width: 0.0001, stopband_attenuation: 80)
        outft = Dsp::FFT.new(time_data: output, size: 2 ** 16)
        all_out = (outft * lpf.fft).ifft.map(&:real)[55000, 1800]
        final_out = []
        for i in 0...all_out.length do
            final_out << all_out[i] if (i + 10) %  sample_interval == 0 
        end
        final_out
    end


    private

    def decode_eqn
        ->(phase){ (phase * m / (2.0 * Math::PI))}
    end
end 