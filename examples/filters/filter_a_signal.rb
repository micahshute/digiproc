plt = Digiproc::QuickPlot
fns = Digiproc::Functions
prob = Digiproc::Probability
norm_dist = Digiproc::Probability::RealizedGaussianDistribution
factory = Digiproc::Factories::FilterFactory

# Make a signal with gaussian noise:
# Create "white" Gaussian noise, 0 mean
dist = norm_dist.new(mean: 0, stddev: 1, size: 16384)

# Create a bandpass filter, make FT dimensions match
bpfilter = factory.filter_for(type: "bandpass", wo: Math::PI / 2, bw: Math::PI / 5, transition_width: 0.0001, stopband_attenuation: 80)
filter_dft = Digiproc::FFT.new(time_data: bpfilter.weights, size: 16384 * 4)

# Get FT of White noise, calculate No 
dist_fft = Digiproc::FFT.new(time_data: dist.data, size: 16384 * 4)
n_o = 2 *  (dist_fft.magnitude.map{ |val| val ** 2}.sum.to_f / dist_fft.data.length)

# Multiply freq domain of noise and filter to get output spectra
# Calculate output energy
filter_out = dist_fft * filter_dft
total_noise_out = filter_out.magnitude.map{ |val| (val ** 2) * (1.0/ (4 * 16384)) }.sum 
time_data_out = fns.ifft(filter_out.data).map(&:real)
bw = 1.0 / 10

puts "Normal Dist. Input \n\tMean:#{prob.mean(dist.data)}, Stddev: #{prob.stddev(dist.data)}"
puts "No = #{n_o}"
puts "Total Noise Energy Out: #{total_noise_out}"
puts "Output: \n\tMean: #{prob.mean(time_data_out)}, Stddev: #{prob.stddev(time_data_out)}"
puts "Calculated Noise Energy Out: #{ n_o * bw}"

f =  fns.linspace(0,1,16384)

path = './examples/filters/'
plt.plot(x: f, y: filter_dft.dB, title: "Bandpass Filter", path: path)
plt.plot(x: f, y: dist_fft.magnitude, title: "White Noise Spectra", path: path)
plt.plot(x: f, y: filter_out.magnitude, title: "White Noise Mag Out of BP Filter", y_label: "Magnitude", path: path)
plt.plot(x: f, y: filter_out.dB, title: "White Noise dB Out of BP Filter", y_label: "dB", path: path)