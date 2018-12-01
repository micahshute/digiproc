# Show that PSK and DPSK modulated signals have the same bandwidth

# Make a 100-bit stream, make one PSK and one DPSK signal, plot the frequency domians

signal2 = Dsp::Probability::RandomBitGenerator.new_bitstream.generate(600).split('')
psk2 = Dsp::Strategies::PSK.new(modulating_signal: signal2, coding_strategy: nil, carrier_frequency: 10, pulse_length: 0.05)
dpsk2 = Dsp::Strategies::PSK.new(modulating_signal: signal2, carrier_frequency: 10, pulse_length: 0.05)
puts dpsk2.coded_signal.to_s
puts dpsk2.phase_signal.to_s
Dsp::QuickPlot.plot(data: psk2.output.to_ds.fft.magnitude, title: "PSK 2")
Dsp::QuickPlot.plot(data: dpsk2.output.to_ds.fft.magnitude, title: "DPSK 2")

# Make 4 256-bit symbols, make one PSK and one DPSK signal, plot the frequency domians
signal256 = Dsp::Probability::RandomBitGenerator.new_symbol_stream(bits_per_symbol: Math.log(256,2).to_i).generate 75
psk256 = Dsp::Strategies::PSK.new(modulating_signal: signal256, coding_strategy: nil, carrier_frequency: 10, pulse_length: 0.4)
dpsk256 = Dsp::Strategies::PSK.new(modulating_signal: signal256, carrier_frequency: 10, pulse_length: 0.4)
s = signal256.map{|a| a.to_i(2)}
puts s.to_s
puts
puts dpsk256.coded_signal.to_s
puts dpsk256.phase_signal.to_s
puts
puts psk256.coded_signal.to_s
puts psk256.phase_signal.to_s
# puts dpsk256.signal_to_phase
Dsp::QuickPlot.plot(data: psk256.output.to_ds.fft.magnitude, title: "PSK 256")
Dsp::QuickPlot.plot(data: dpsk256.output.to_ds.fft.magnitude, title: "DPSK 256")