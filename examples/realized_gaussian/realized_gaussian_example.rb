plt = Dsp::QuickPlot
gauss = Dsp::Probability::RealizedGaussianDistribution
fns = Dsp::Functions

distribution = gauss.new(mean: 0, stddev: 10, size: 100)
data = distribution.data

#qplot function in quickplot gives a different plot API
plt.qplot(data: data, path: './examples/realized_gaussian/', filename: 'norm_dist_plot', xsteps: 10, data_name: "normal random numbers") do |g|
    g.title = "Gaussian Random Numbers"
    g.theme = Dsp::Plottable::Styles::MIDNIGHT
    g.show_vertical_markers = false
end

spectra = fns.fft(data).map(&:abs)
x_vals = fns.linspace(0,128,128)

plt.qplot(data: spectra, path: './examples/realized_gaussian/', filename: 'norm_dist_spectrum', xsteps: 4, xyname: "spectra mag. of norm. random nums") do |g|
    g.title = "Gaussian Nums: Frequency Domain"
    g.labels = {0 => 0, 32 => 0.25, 64 => 0.5, 98 => 0.75, 127 => 1}
    g.show_vertical_markers = false
end

