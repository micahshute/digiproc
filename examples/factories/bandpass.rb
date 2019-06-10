Filter_factory = Digiproc::Factories::FilterFactory
plt = Digiproc::QuickPlot
bpfilter = Filter_factory.filter_for(type: "bandpass", wo: Math::PI / 3, bw: Math::PI / 10, transition_width: 0.1, stopband_attenuation: 80)
freq_db = bpfilter.fft.dB
# Get x values with the linspace function (start, stop, number_of_points)
plt.plot(x: Digiproc::Functions.linspace(0,1,freq_db.length) ,y: freq_db, y_label: "dB", dark: true, path: './examples/factories/')