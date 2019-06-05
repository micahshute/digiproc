# We want to transmit the data sequence 110100010110 using binary DPSK. 
# Let s(t)=Acos(2πfot+θ) represent the transmitted signal in a signaling interval of duration Tb. 
# Give the phase of the tranmitted signal. Begin with θ=0 for the phase of the first bit to be transmitted.


 
sig_str = "110100010110"
sig = sig_str.split('')
# diff_sig = Dsp::Strategies::XORDifferentialEncodingStrategy.encode(sig, 2, "0")
 
# System 1: 
#Use XOR to encode original signal with a delayed version of itself
# Map bits 0 => 0 rad, 1 => pi rad
bpsk = Dsp::Strategies::PSK.new(modulating_signal: sig, coding_strategy: Dsp::Strategies::XORDifferentialEncodingZeroAngleStrategy)

# System 2:
# Use XOR to encode original signal with a delayed version of itself
# Map bits 0 => pi, 1 => 3pi/2
bdpsk = Dsp::Strategies::PSK.new(modulating_signal: sig, coding_strategy: Dsp::Strategies::XORDifferentialEncodingStrategy)

# System 3: 
# Do not XOR the bits but instead map them directly into frequencies which then are added to dealyed versions
# of themselves modulo 2pi (see the strategy used for more details)
dpsk = Dsp::Strategies::PSK.new(modulating_signal: sig, coding_strategy:Dsp::Strategies::DifferentialEncodingStrategy)

#System 4:
# Directly maps bits to phase without XORing and does not alter phase angles at all for transmission
dpsk2 = Dsp::Strategies::PSK.new(modulating_signal: sig) 

xvals = Dsp::Functions.linspace(1,sig_str.length, sig_str.length + 1)


puts "System 1 Differential Signal: #{bpsk.coded_signal}"
puts "System 1 Phase: #{bpsk.phase_signal.map{ |ps| ps / Math::PI }} * pi"
puts "System 1 Decoded: #{bpsk.decode}"

dpskvals = bpsk.phase_signal.map{ |p| p / Math::PI}
path = "./examples/encoding/"
plt = Dsp::Rbplot.line(xvals, dpskvals)
plt.xlabel("sample number")
plt.ylabel("phase ( *pi rad )")
plt.title("XOR DPSK Phase Signal (Sys1)")
plt.legend("DPSK angle")
plt.show(path)

qplt = Dsp::QuickPlot
puts "\n\n"
puts "System 2 Differential Signal: #{bdpsk.coded_signal}"
puts "System 2 Coded Phase: #{bdpsk.phase_signal.map{ |ps| ps / Math::PI}} * pi"
puts "System 2 Decoded: #{bdpsk.decode}"
qplt.plot(data: bdpsk.phase_signal.map{ |p| p / Math::PI},y_label: "Phase", title: "System 2 Phase", path: path)
puts "\n\n"
 
puts "System 3 Signal: #{dpsk.coded_signal}"
puts "System 3 Coded Phase: #{dpsk.phase_signal.map{ |p| p / Math::PI}} * pi"
puts "System 3 Decoded: #{dpsk.decode}"
puts "(This is not correct)"
qplt.plot(data: dpsk.phase_signal.map{ |p| p / Math::PI},y_label: "Phase", title: "System 3 Phase", path: path)
puts "\n\n"
 

puts "System 4 Signal: #{dpsk2.coded_signal}"
puts "System 4 Coded Phase: #{dpsk2.phase_signal.map{ |p| p / Math::PI}} * pi"
puts "System 4 Decoded: #{dpsk2.decode}"
qplt.plot(data: dpsk2.phase_signal.map{ |p| p / Math::PI},y_label: "Phase", title: "System 3 Phase", path: path)
puts "\n\n"


yvals = bpsk.output.digitize 
xvals = Dsp::Functions.linspace(1,yvals.length, yvals.length)
plt = Dsp::Rbplot.line(xvals, yvals)
plt.title("XOR DPSK Xmit Signal (Sys 1)")
plt.xlabel("Sample number")
plt.ylabel("Signal Amplitude")
plt.legend("DPSK Xmit Signal")
plt.theme(:dark)
plt.show(path)


qplt.plot(data: bdpsk.output.digitize, title: "System 2 Xmit Signal", y_label: "Magnitude", dark: true, path: path)
qplt.plot(data: dpsk.output.digitize, title: "System 3 Xmit Signal", y_label: "Magnitude", dark: true, path: path)
qplt.plot(data: dpsk2.output.digitize, title: "System 4 Xmit Signal", y_label: "Magnitude", dark: true, path: path)

puts "System 1 Output From Reciever: \n#{bpsk.reciever_decode}\n\n"
puts "Correctly decoded by reciever \n"
puts "System 2 Output From Reciever: \n#{bdpsk.reciever_decode}\n\n"
puts "Correctly decoded by reciever \n"
puts "System 3 Output From Reciever: \n#{dpsk.reciever_decode}\n\n"
puts "Not properly decoded by reciever"
puts "System 4 Output From Reciever: \n#{dpsk2.reciever_decode}\n\n"
puts 'Not properly decoded by reciever'
