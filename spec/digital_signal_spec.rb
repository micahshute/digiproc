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


    it "allows creation of a digital signal with an arary of data" do 
        data = linspace.map{ |n| cos_pi_over_ten.call(n)}
        ds = DigitalSignal.new(data: data)
        expect(ds).to be
        expect(ds.i 10).to eq(data[10])
        expect(ds.i 5, 10).to eq(data[5, 6])
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


    it "can be convolved with another digital signal" do
        expect(periodic_signal.conv(mod_signal)).to be
        ds1 = DigitalSignal.new(data: [1,2,3,4])
        ds2 = DigitalSignal.new(data: [1,2,3,4])
        expect(ds1.conv(ds2)).to eq([1, 4, 10, 20, 25, 24, 16])
    end

    it "#ds_conv convoles and produces a new DigitalSignal" do
        expect(periodic_signal.ds_conv(mod_signal).is_a? DigitalSignal).to be(true)
        expect(periodic_signal.ds_conv(mod_signal).data).to eq(Dsp.conv(periodic_signal.data, mod_signal.data))
        expect(periodic_signal.ds_conv(mod_signal).data).to eq(periodic_signal.conv(mod_signal))
    end

    it "ds_conv and conv can accept a dignal or an array" do
        expect(periodic_signal.ds_conv(mod_signal).data).to eq(periodic_signal.ds_conv(mod_signal.data).data)
        expect(periodic_signal.conv(mod_signal)).to eq(periodic_signal.conv(mod_signal.data))
    end

    it "can create an fft of itself" do
        expect(periodic_signal.fft.is_a?(Dsp::FFT)).to eq(true)
        expect(periodic_signal.fft.calculate).to eq(Dsp::FFT.new(data: periodic_signal.data).calculate)
    end

    it "can calculate magnitude of its values" do 
        expect(true).to eq(false)
    end

    it "can calculate angle of its values" do
        expect(true).to eq(false)        
    end

    it "can display its power spectral density (fft of autocorrelation)" do
        expect(true).to eq(false)
    end
end