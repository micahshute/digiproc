# Define required objects and constants
r = Random.new
pulse_lens = [1,2]
plt = Dsp::QuickPlot
fns = Dsp::Functions
a = 1

# Random signal generator functions
def get_signal(rand_gen, a = 1)
    rand_gen.rand(2) == 0 ? -a : a
end

# Create signal data
signal_size = 400
sample_rate = 0.05
signal_arr = []
signal_size.times { signal_arr << get_signal(r, a)}

#Get results with varied pulse length
pulse_lens.each do |pulse_len|
    size = (1.0 / sample_rate) * signal_size * pulse_len
    # Correct for sample rate so it can be compared to CT equation
    signal_eqn = ->(t){ signal_arr[(t / pulse_len.to_f).floor] * sample_rate }
    signal = Dsp::AnalogSignal.new(eqn: signal_eqn, sample_rate: sample_rate, size: size)
    freq_of_interest1 = 1.0 / (2 * pulse_len)
    freq_of_interest2 = 1.0 / ( pulse_len)
    # Test calculated equation 
    x_f = Proc.new do |f|
        signal_arr.map.with_index{ |s, n| s.to_f * (a / (Complex(0, f * 2 * Math::PI))) * (Math::E ** (Complex(0, -f * Math::PI * 2 * n * pulse_len)) - Math::E ** (Complex(0,-f * 2 * Math::PI * pulse_len) * (1 + n))) }.sum
    end
    max_freq = 0.5 / (sample_rate)
    freq_space = fns.linspace(0, max_freq, size)
    xf_plot = fns.process(freq_space, x_f).map(&:abs)
    #Equation DNE @ omega = 0
    xf_plot[0] = 0

    foi1_from_eqn = ((freq_of_interest1.to_f / max_freq) * xf_plot.length).to_i
    foi2_from_eqn = ((freq_of_interest2.to_f / max_freq) * xf_plot.length).to_i
    # puts signal.to_ds.fft.magnitude[(foi1_from_eqn / 2 - 1).to_i]
    puts "Magnitude at 1/2T : #{xf_plot[foi1_from_eqn]}"
    puts "Magnitude at 1/T  : #{xf_plot[foi2_from_eqn]}"
    puts
    # Plot output from derived equation
    plt.plot(data: xf_plot, title: "Freq Sig from Eqn, Ts = #{pulse_len} s")

    # Plot experiment data
    plt.plot(data: signal.digitize, title: "Time signal, Ts = #{pulse_len} s")
    plt.plot(data: signal.to_ds.fft.magnitude, title: "Frequency Signal, Ts = #{pulse_len} s")
    plt.plot(data: signal.to_ds.psd.data.map(&:real), title: "Power Spectral Density,  Ts = #{pulse_len} s")
end

puts
puts 

alpha = 1
coded_arr = Array.new(signal_size, 0)
coded_arr[0] = signal_arr.first
for i in 1...signal_size do
    coded_arr[i] = signal_arr[i] + alpha * signal_arr[i-1]
end

pulse_lens.each do |pulse_len|
    size = (1.0 / sample_rate) * signal_size * pulse_len
    signal_eqn = ->(t){ coded_arr[(t / pulse_len.to_f).floor] * sample_rate }
    signal = Dsp::AnalogSignal.new(eqn: signal_eqn, sample_rate: sample_rate, size: size)
    freq_of_interest1 = 1.0 / (2 * pulse_len)
    freq_of_interest2 = 1.0 / ( pulse_len)

    x_f = Proc.new do |f|
        coded_arr.map.with_index{ |s, n| s.to_f * (a / (Complex(0, f * 2 * Math::PI))) * (Math::E ** (Complex(0, -f * Math::PI * 2 * n * pulse_len)) - Math::E ** (Complex(0,-f * 2 * Math::PI * pulse_len) * (1 + n))) }.sum
    end
    max_freq = 0.5 / (sample_rate)
    freq_space = fns.linspace(0, max_freq, size)
    xf_plot = fns.process(freq_space, x_f).map(&:abs)
    xf_plot[0] = 0
    # freq_unit = size.to_f / max_freq
    foi1_from_eqn = ((freq_of_interest1.to_f / max_freq) * xf_plot.length).to_i
    foi2_from_eqn = ((freq_of_interest2.to_f / max_freq) * xf_plot.length).to_i
    # puts signal.to_ds.fft.magnitude[(foi1_from_eqn / 2 - 1).to_i]
    puts "Coded Magnitude at 1/2T : #{xf_plot[foi1_from_eqn]}"
    puts "Coded Magnitude at 1/T  : #{xf_plot[foi2_from_eqn]}"
    plt.plot(data: xf_plot, title: "Coded Freq Sig from Eqn, Ts = #{pulse_len} s")
    
    #Plot test data
    plt.plot(data: signal.digitize, title: "Coded Time signal, Ts = #{pulse_len} s")
    plt.plot(data: signal.to_ds.fft.magnitude, title: " Coded Frequency Signal, Ts = #{pulse_len} s")
    plt.plot(data: signal.to_ds.psd.data.map(&:real), title: "Coded Power Spectral Density,  Ts = #{pulse_len} s")
end