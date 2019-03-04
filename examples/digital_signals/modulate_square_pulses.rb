
input_data = Array.new(10,0) + Array.new(10,1) + Array.new(20,0) + Array.new(20,1) + Array.new(40,0)
x_n = Dsp::DigitalSignal.new(data: input_data)
lpf = Dsp::Factories::FilterFactory.filter_for(type: 'lowpass', wc: Math::PI / 10, transition_width: 0.01, stopband_attenuation: 80).to_ds
carrier = Dsp::DigitalSignal.new_from_eqn(eqn: ->(n){Math.cos(10.0 * 2.0 * Math::PI * n / 100) }, size: lpf.data.length)
y_n =  Dsp::DigitalSignal.new(data: (x_n.fft(2**8) * lpf.fft(2**8)).ifft.map(&:real).take(100)) * carrier * carrier
y_n_alt = x_n.ds_conv(lpf) * carrier * carrier
Dsp::QuickPlot.plot(data: y_n.data, title: "Modulated Sq. Pulses", path: './examples/digital_signals/')
Dsp::QuickPlot.plot(data: y_n_alt.data[274,100], title: "Modulated Sq. Pulses Alt", path: './examples/digital_signals/')