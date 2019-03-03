# Sample an analog signal, turn into digital signal and calculate the FFT
plt = Dsp::QuickPlot
# analog_signal_eqn = ->(t){ (t >= 0 and t <= 0.1) ? (100 * t * Math.cos(2*Math::PI*2.5*t)) : 0 }
analog_signal_eqn = ->(t){ Math.cos(2*Math::PI * 100 * t) + Math.cos(2 * Math::PI * 2500 * t) }

analog_signal = Dsp::AnalogSignal.new(eqn: analog_signal_eqn, sample_rate: 0.0001, size: 10000)

digital_signal = analog_signal.to_ds

fft = digital_signal.fft

fft.plot_magnitude(path: './examples/analog_signals/')