plt = Dsp::QuickPlot
prob = Dsp::Probability
norm_dist = Dsp::Probability::RealizedGaussianDistribution
window = BlackmanWindow.new(size: 16384)

#************ Find a signal in noise with FFT ****************

#sample every 1 ms
sample_rate = 0.001
datapoints = 16384 # use a power of 2 because FFT uses Radix 2 algorithm
#300Hz and 500Hz signals
signal = Dsp::AnalogSignal.new(eqn: ->(t){0.2 * Math.cos(2*Math::PI * 300 * t) + 0.3 * Math.cos(2 * Math::PI * 400 * t)}, sample_rate: sample_rate, size: datapoints).to_ds
data = signal.data
noise = norm_dist.new(mean: 0, stddev: 1, size: datapoints)
#Add signal to noise data
recieved_signal = data.plus(noise.data)

#process signal with a blackman window (below shows that this is an optional step)
processed_signal_data = recieved_signal.times window.data

processed_signal = DigitalSignal.new(data: processed_signal_data)

fft = processed_signal.fft

#Get the 
signal_locations = fft.maxima(4)

puts signal_locations

max_freq_hz = 0.5 / sample_rate
max_freq_datapoint = datapoints / 2

# Only use signals below Nyquist Frequency
signal_locations.select!{ |location| location.index < max_freq_datapoint }

signal_1_freq = signal_locations[0].index.to_f / max_freq_datapoint * max_freq_hz
signal_2_freq = signal_locations[1].index.to_f / max_freq_datapoint * max_freq_hz

puts "Most powerful signal at #{signal_1_freq} Hz"
puts "Second most powerful signal at #{signal_2_freq} Hz"

#Signal not viewable in time domain
plt.plot(data: recieved_signal, title: "Recieved data (time domain)", path: './examples/fft/' )
#Signal easily viewed in frequency domain (dB plot)
fft.plot_db(path: "./examples/fft/")
#plot unprocessed signal dB
plt.plot(data: DigitalSignal.new(data: recieved_signal).fft.dB , title: "Unprocessed FFT", path: './examples/fft/')