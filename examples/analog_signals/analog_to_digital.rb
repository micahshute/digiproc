# Sample an analog signal, turn into digital signal and calculate the FFT
plt = Dsp::QuickPlot
analog_signal_eqn = ->(t){ (t >= 0 and t <= 0.1) ? (100 * t * Math.cos(Math::PI*2.5*t)) : 0 }

analog_signal_eqn = ->(t){ Math.cos(2*Math::PI * 50 * t) + Math.cos(2 * Math::PI * 1250 * t) }

analog_signal = Dsp::AnalogSignal.new(eqn: analog_signal_eqn, sample_rate: 0.001, size: 1000)

digital_signal = analog_signal.to_ds

fft = digital_signal.fft

fft.plot_magnitude(path: './examples/analog_signals/')

rate = 0.01
size = 1000
fn = ->(x){ Math.sin(x) }
as64 = Dsp::AnalogSignal.new(eqn: fn, sample_rate: rate, size: size, quantization_bits: 64, quant_max: 1, quant_min: -1)
as8 = Dsp::AnalogSignal.new(eqn: fn, sample_rate: rate, size: size, quantization_bits: 8, quant_max: 1, quant_min: -1)
as4 = Dsp::AnalogSignal.new(eqn: fn, sample_rate: rate, size: size, quantization_bits: 4, quant_max: 1, quant_min: -1)
t = Dsp::Functions.linspace(0, rate * size, size)
plt = Dsp::Rbplot.line(t, as64.digitize, "64 bits")
plt.add_line(t, as8.digitize, '8 bits')
plt.add_line(t, as4.digitize, '4 bits')
plt.path('./examples/analog_signals/')
plt.title('Quantization Outputs')
plt.xlabel('time (s)')
plt.ylabel('magnitude')
plt.xsteps(10)
plt.theme(:dark)
plt.show