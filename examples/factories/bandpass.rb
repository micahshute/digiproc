factory = Dsp::Factories::FilterFactory
plt = Dsp::QuickPlot
bpfilter = factory.filter_for(type: "bandpass", wo: Math::PI / 3, bw: Math::PI / 10, transition_width: 0.1, stopband_attenuation: 80)
freq_db = bpfilter.fft.dB
plt.plot(x: Dsp::Functions.linspace(0,1,freq_db.length) ,y: freq_db)