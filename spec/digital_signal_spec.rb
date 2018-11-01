RSpec.describe DigitalSignal do 

    let(:linspace) do
        (0...64).to_a
    end

    let(:cos_pi_over_ten) do 
        ->(n){ Math.cos(n * Math::PI / 10) }
    end

    let(:n) do
        ->(n){ n }
    end

    let(:n_mod_4) do
        ->(n){ n % 4 }
    end

    let(:periodic_signal) do
        DigitalSignal.new_from_eqn(eqn: cos_pi_over_ten, size: 32)
    end

    let(:mod_signal) do
        DigitalSignal.new_from_eqn(eqn: n_mod_4, size: 32)
    end

    let(:short_signal_a) do
        DigitalSignal.new(data: [91, 23, 11, 53, 12, 82, 62])
    end

    let(:short_signal_b) do
        DigitalSignal.new(data: [5,4,2,3])
    end

    let (:xcorr_short_a_b) do
        [273, 251, 443, 728, 301, 537, 663, 512, 658, 310]
    end

    let (:acorr_short_a) do
        [5642, 8888, 3660, 9287, 7442, 9633, 22452, 9633, 7442, 9287, 3660, 8888, 5642]
    end

    let (:power_spectrum_short_a) do
        [
            Complex(111556, 0.0), Complex(-30478.0197358128, -30478.0197358128),	Complex(0.0, 3051.78775020902),
            Complex(18767.9848609230, -18767.9848609230), Complex(-3604, 0), Complex(9383.93804147773, 9383.93804147773), 
            Complex(0, -27212.2122497910), Complex(-4873.90316658790, 4873.90316658790), Complex(324, 0), Complex(-4873.90316658790, -4873.90316658790),
            Complex(0, 27212.2122497910), Complex(9383.93804147773, -9383.93804147773), Complex(-3604, 0), Complex(18767.9848609230, 18767.9848609230),
            Complex(0, -3051.78775020902), Complex(-30478.0197358128, 30478.0197358128)
        ]
        .map{ |val| Complex(val.real.round(7), val.imag.round(7)) }
    end


    it "allows creation of a digital signal with an arary of data, #i can access any run or singular datapoints" do 
        data = linspace.map{ |n| cos_pi_over_ten.call(n)}
        ds = DigitalSignal.new(data: data)
        expect(ds).to be
        expect(ds.i 10).to eq(data[10])
        expect(ds.i 5..10).to eq(data[5, 6])
        expect(ds.i 5..10, 0...5).to eq(data[5, 6].concat(data[0,5]))
        expect(ds.values_between 5, 10).to eq(data[5, 6])
        expect(ds.i 5, 10).to eq([data[5], data[10]])
    end


    it "allows creation of a digital signal with an equation and size" do
        ds = DigitalSignal.new_from_eqn(eqn: cos_pi_over_ten, size: 20)
        expect(ds).to be
        expect(ds.i 10).to eq(cos_pi_over_ten.call 10)
    end

    it "allows creation of a digital signal with an array of equations and ranges" do
        ranges = [0..10, 11..15, 15..20]
        eqns = [cos_pi_over_ten, n, n_mod_4]
        ds = DigitalSignal.new_from_equations(eqns: eqns, ranges: ranges)
        ds2 = DigitalSignal.new_from_equations(eqns: eqns, ranges: [0..10, 11..15, 15..20])
        expect(ds.i 7).to eq(cos_pi_over_ten.call(7))
        expect(ds.i 13).to eq(n.call(13))
        expect(ds.i 17).to eq(n_mod_4.call(17))
        expect(ds2.i 6).to eq(ds.i 6)
        expect(ds2.i 12).to eq(ds.i 12)
        expect(ds2.i 18).to eq(ds.i 18)
    end

    it "can return a data value, and returns a 0 outside the range" do
        ds = DigitalSignal.new(data: [1,2,3,4,5])
        expect(ds.i 10).to eq(0)
        expect(ds.i 10000).to eq(0)
    end


    it "#conv allows it to be convolved with another digital signal (or any convolvable object)" do
        expect(periodic_signal.conv(mod_signal)).to be
        ds1 = DigitalSignal.new(data: [1,2,3,4])
        ds2 = DigitalSignal.new(data: [1,2,3,4])
        expect(ds1.conv(ds2)).to eq([1, 4, 10, 20, 25, 24, 16])
    end

    it "#ds_conv convoles with a DigitalSignal and produces a new DigitalSignal" do
        expect(periodic_signal.ds_conv(mod_signal).is_a? DigitalSignal).to be(true)
        expect(periodic_signal.ds_conv(mod_signal).data).to eq(Dsp.conv(periodic_signal.data, mod_signal.data))
        expect(periodic_signal.ds_conv(mod_signal).data).to eq(periodic_signal.conv(mod_signal))
    end

    it "#ds_conv and conv can accept a digital signal nal or an array" do
        expect(periodic_signal.ds_conv(mod_signal).data).to eq(periodic_signal.ds_conv(mod_signal.data).data)
        expect(periodic_signal.conv(mod_signal)).to eq(periodic_signal.conv(mod_signal.data))
    end

    it "#fft.calculate can create an fft of itself, accessible via @fft" do
        expect(periodic_signal.fft.is_a?(Dsp::FFT)).to eq(true)
        expect(periodic_signal.fft.calculate).to eq(Dsp::FFT.new(data: periodic_signal.data).calculate)
        expect(periodic_signal.fft.fft.length).to eq(32)
    end

    it "#fft_magnitude can calculate magnitude of its values" do 
        expect(periodic_signal.fft_magnitude).to eq(Dsp::FFT.new(data: periodic_signal.data).calculate.map{ |val| val.abs})
    end

    it "#fft_angle can calculate angle of its values" do
        expect(periodic_signal.fft_angle).to eq(Dsp::FFT.new(data: periodic_signal.data).calculate.map{ |val| val.angle })
    end

    it "#cross_correlation returns an array of its cross-correlation with an array or a correlatable" do
        expect(periodic_signal.cross_correlation(mod_signal).is_a? Array).to eq(true)
        expect(periodic_signal.cross_correlation(mod_signal.data).is_a? Array).to eq(true)
        expect(short_signal_a.cross_correlation(short_signal_b)).to eq(xcorr_short_a_b)
        expect(short_signal_a.cross_correlation(short_signal_b.data)).to eq(xcorr_short_a_b)
    end


    it "#ds_cross_correlation returns a DigitalSignal of its cross-correlation with an array or a correlatable" do
        expect(periodic_signal.ds_cross_correlation(mod_signal).is_a? DigitalSignal).to eq(true)
        expect(periodic_signal.ds_cross_correlation(mod_signal.data).is_a? DigitalSignal).to eq(true)
        expect(short_signal_a.ds_cross_correlation(short_signal_b).data).to eq(xcorr_short_a_b)
        expect(short_signal_a.ds_cross_correlation(short_signal_b.data).data).to eq(xcorr_short_a_b)
    end

    it "xcorr is an alias for #cross_correlaion" do
        expect(periodic_signal.xcorr(mod_signal)).to eq(Dsp.cross_correlation(periodic_signal.data, mod_signal.data))
        expect(mod_signal.xcorr(periodic_signal.data)).to eq(Dsp.cross_correlation(mod_signal.data, periodic_signal.data))
    end

    it "ds_xcorr is an alias for ds_cross_correlation" do
        expect(periodic_signal.ds_xcorr(mod_signal).is_a? DigitalSignal).to eq(true)
        expect(periodic_signal.ds_xcorr(mod_signal).data).to eq(Dsp.cross_correlation(periodic_signal.data, mod_signal.data))
        expect(mod_signal.ds_xcorr(periodic_signal.data).data).to eq(Dsp.cross_correlation(mod_signal.data, periodic_signal.data))
    end

    it "#auto_correlation returns an array of the signal's auto correlation" do
        expect(short_signal_a.auto_correlation).to eq(acorr_short_a)
        expect(periodic_signal.auto_correlation).to eq(Dsp.cross_correlation(periodic_signal.data, periodic_signal.data))
    end

    it "#ds_auto_correlation returns a DigitalSignal of the signal's auto correlation" do
        expect(periodic_signal.ds_auto_correlation.is_a? DigitalSignal).to eq(true)
        expect(periodic_signal.ds_auto_correlation.data).to eq(periodic_signal.auto_correlation)
        expect(short_signal_a.ds_auto_correlation.data).to eq(acorr_short_a)
    end

    it "#acorr is an alias for auto_correlation" do
        expect(periodic_signal.acorr).to eq(periodic_signal.auto_correlation)
        expect(short_signal_a.acorr).to eq(acorr_short_a)
    end

    it "#ds_acorr is an alias for ds_auto_correlation" do
        expect(periodic_signal.ds_acorr.is_a? DigitalSignal).to eq(true)
        expect(periodic_signal.ds_acorr.data).to eq(periodic_signal.ds_auto_correlation.data)
        expect(short_signal_a.ds_acorr.data).to eq(acorr_short_a)
    end


    it "#power_spectral_density can return its power spectral density (fft of autocorrelation) as an Dsp::FFT class" do
        expect(periodic_signal.power_spectral_density.is_a? Dsp::FFT).to eq(true)
        expect(short_signal_a.power_spectral_density.fft.map { |val| val.is_a?(Complex) ? Complex(val.real.round(7), val.imaginary.round(7)) : Complex(val.round(5), 0)}).to eq(power_spectrum_short_a)
    end

    it "#psd is an alias for #power_spectral_density" do
        expect(periodic_signal.psd.is_a? Dsp::FFT).to eq(true)
        expect(short_signal_a.psd.fft.map { |val| val.is_a?(Complex) ? Complex(val.real.round(7), val.imaginary.round(7)) : Complex(val.round(5), 0)}).to eq(power_spectrum_short_a)
    end

    it "#cross_spectral_density takes a signal and can return a Dsp::FFT" do
        expect(periodic_signal.cross_spectral_density(short_signal_a.data).is_a? Dsp::FFT).to eq(true)
        expect(short_signal_a.cross_spectral_density(short_signal_a).fft.map { |val| val.is_a?(Complex) ? Complex(val.real.round(7), val.imaginary.round(7)) : Complex(val.round(5), 0)}).to eq(power_spectrum_short_a)
    end

    it "#csd is an alias for @cross_spectral_density" do
        expect(periodic_signal.csd(short_signal_a).is_a? Dsp::FFT).to eq(true)
        expect(short_signal_a.csd(short_signal_a.data).fft.map { |val| val.is_a?(Complex) ? Complex(val.real.round(7), val.imaginary.round(7)) : Complex(val.round(5), 0)}).to eq(power_spectrum_short_a)
    end
end