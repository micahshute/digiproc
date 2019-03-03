plt = Dsp::QuickPlot

sig_str = "110100010110"
sig = sig_str.split('')
diff_sig = Dsp::Strategies::XORDifferentialEncodingStrategy.encode(sig, 2, "0")

bpsk = Dsp::Strategies::PSK.new(modulating_signal: diff_sig, coding_strategy: nil)
bdpsk = Dsp::Strategies::PSK.new(modulating_signal: sig)
dpsk = Dsp::Strategies::PSK.new(modulating_signal: sig, coding_strategy: Dsp::Strategies::DifferentialEncodingStrategy)

puts "System 1 Differential Signal: #{bpsk.coded_signal}"
puts "System 1 Phase: #{bpsk.phase_signal.map{ |ps| ps / Math::PI }} * pi"
puts "System 1 Decoded: #{bpsk.decode}"
plt.plot(data: bpsk.phase_signal.map{ |p| p / Math::PI}, y_label: "Phase", title: "System 1 Phase")
puts "\n\n"
puts "System 2 Differential Signal: #{bdpsk.coded_signal}"
puts "System 2 Coded Phase: #{bdpsk.phase_signal.map{ |ps| ps / Math::PI}} * pi"
puts "System 2 Decoded: #{bdpsk.decode}"
plt.plot(data: bdpsk.phase_signal.map{ |p| p / Math::PI},y_label: "Phase", title: "System 2 Phase")
puts "\n\n"

puts "System 3 Signal: #{dpsk.coded_signal}"
puts "System 3 Coded Phase: #{dpsk.phase_signal.map{ |p| p / Math::PI}} * pi"
puts "System 3 Decoded: #{dpsk.decode}"
plt.plot(data: dpsk.phase_signal.map{ |p| p / Math::PI},y_label: "Phase", title: "System 3 Phase")
puts "\n\n"

# dpsk_output = dpsk.output
# time_range = Dsp::Functions.linspace(0, dpsk_output.sample_rate * dpsk_output.size, dpsk_output.size)
path = "./examples/modulation_schemes/"
plt.plot(data: bpsk.output.digitize, title: "System 1 Xmit Signal", y_label: "Magnitude", dark: true, path: path)
plt.plot(data: bdpsk.output.digitize, title: "System 2 Xmit Signal", y_label: "Magnitude", dark: true, path: path)
plt.plot(data: dpsk.output.digitize, title: "System 3 Xmit Signal", y_label: "Magnitude", dark: true, path: path)
puts "System 1 Output From Reciever: \n#{bpsk.reciever_decode}\n\n"
puts "System 2 Output From Reciever: \n#{bdpsk.reciever_decode}\n\n"
puts "System 3 Output From Reciever: \n#{dpsk.reciever_decode}\n\n"
