# Show that PSK and DPSK modulated signals have the same bandwidth

# Define DPSK encoding/decoding strategy
dpsk_strategy = Dsp::Strategies::XORDifferentialEncodingZeroAngleStrategy

# *********** NOTE: Dsp::Strategies::DifferentialEncodingStrategy encodes for an M-ary PSK signal, requires decoding
# via reciever in figure 4-15 of INTRODUCITON TO DIGITAL COMMUNICATION, ZIEMER, PETERSON which has not been implemented.

# Not adding a coding strategy into PSK causes bit to phase mapping to not be differentially encoded

# Make a 100-bit stream, make one PSK (Phase Shift Keying) and one DPSK (Differential PSK) signal, plot the frequency domians

signal2 = Dsp::Probability::RandomBitGenerator.new_bitstream.generate(600).split('')
psk2 = Dsp::Strategies::PSK.new(modulating_signal: signal2, carrier_frequency: 10, pulse_length: 0.05)
dpsk2 = Dsp::Strategies::PSK.new(modulating_signal: signal2, coding_strategy: dpsk_strategy, carrier_frequency: 10, pulse_length: 0.05)

puts "PSK Signal"
puts "Coded"
puts psk2.coded_signal.to_s
puts "Phase"
puts psk2.phase_signal.to_s


puts "DPSK Signal"
puts "Coded"
puts dpsk2.coded_signal.to_s
puts "Phase"
puts dpsk2.phase_signal.to_s

puts "Original signal:"
puts "#{signal2}"
puts "Decoded signal:"
# NOTE: decoded signals are not simulating a reciever, but just reversing the coding strategy
puts "DPSK"
puts "#{dpsk2.decode}"
puts "PSK"
puts "#{psk2.decode}"
puts "Match check"
puts "DPSK decode matches original:"
puts signal2 == dpsk2.decode
puts "PSK decode matches original:"
puts signal2 == psk2.decode.map{ |i| i.to_i.to_s }

# Below simulates a receiver per fig. 4-14 in INTRODUCTION TO DIGITAL COMMUNICATIONS, ZIEMER, PETERSON
# Reciever is of the form: phase signal -> Bandwidth Filter 0.57 / Tb -> Delay -> multiply -> Lowpass Filter -> Sample at t = Tb -> Output
                                                                      #|-bypass-->{up_arrow}

#Example below fails, if you have time and want to help troubleshoot, please contribute! First
# 200 samples are showing up, and the rest seem to be wrapped in the front of the ifft. See 
# Dsp::Strategies::PSK#reciever_out for troubleshooting

puts "Simulated DPSK reciever output:"
receiver_out = dpsk2.reciever_decode
puts receiver_out.to_s
puts receiver_out.map{ |i| i.to_f <=> 0 }.map{ |i| i == -1 ? 0 : 1 }.to_s
puts "Test equality of signal"
test_sig =  receiver_out.map{ |i| (i.to_f <=> 0).to_s }.map{ |i| i == "-1" ? "0" : "1" } 

# Note - this reciever only works for small signals at this time. 
# The FFT funciton needs to be optimized to automatically set the appropriate size
# based off of the input function 



puts test_sig.size
puts signal2.size
puts test_sig == signal2
puts test_sig == signal2.take(test_sig.length)

test_sig.each_with_index do |sym, i| 
    if test_sig[i] != signal2[i]
        puts "Signal fails at index #{i}"
        puts signal2[i - 10, 50].to_s
        puts test_sig[i - 10, 50].to_s
        break
    end
end

path = "./examples/modulation_schemes/"

Dsp::QuickPlot.plot(data: psk2.output.to_ds.fft.magnitude, title: "PSK 2", path: path)
Dsp::QuickPlot.plot(data: dpsk2.output.to_ds.fft.magnitude, title: "DPSK 2", path: path)

# Make 75 8-bit symbols, make one PSK and one DPSK signal, plot the frequency domians
signal256 = Dsp::Probability::RandomBitGenerator.new_symbol_stream(bits_per_symbol: Math.log(256,2).to_i).generate 75
psk256 = Dsp::Strategies::PSK.new(modulating_signal: signal256, carrier_frequency: 10, pulse_length: 0.4)
dpsk256 = Dsp::Strategies::PSK.new(modulating_signal: signal256, coding_strategy: dpsk_strategy ,carrier_frequency: 10, pulse_length: 0.4)
s = signal256.map{|a| a.to_i(2)}

puts "Original signal"
puts s.to_s
puts
puts "DPSK Signal"
puts "Coded"
puts dpsk256.coded_signal.to_s
puts "Phase"
puts dpsk256.phase_signal.to_s
puts
puts "PSK Signal"
puts "Coded"
puts psk256.coded_signal.to_s
puts "Phase"
puts psk256.phase_signal.to_s

Dsp::QuickPlot.plot(data: psk256.output.to_ds.fft.magnitude, title: "PSK 256", path: path)
Dsp::QuickPlot.plot(data: dpsk256.output.to_ds.fft.magnitude, title: "DPSK 256", path: path)

puts "Original Signal"
puts "#{signal256}"

puts "Decoded signal"
puts "Decoded DPSK"
puts "#{dpsk256.decode}"
puts "Decoded PSK"
puts "#{psk256.decode}"

puts "Match check:"
puts "#{signal256 == dpsk256.decode}"
puts "#{signal256 == psk256.decode.map{ |i| i.to_i.to_s }}"