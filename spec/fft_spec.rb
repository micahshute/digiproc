RSpec.describe Dsp::FFT do

    let(:eqn1) do
        ->(n){ Math.cos(n * (1.0/10) * Math::PI)}
    end

    let(:eqn2) do
        ->(n){ Math.cos(n * 8.0 / 64 * Math::PI)}
    end

    let(:eqn3) do
        ->(n){ Math.cos(n * 20.0 / 64 * Math::PI)}
    end

    let(:eqn1_size) do
        64
    end

    let(:range) do
        (1..eqn1_size).to_a
    end

    let(:range_zero_start) do
        (0...eqn1_size).to_a
    end

    let (:data) do
        range_zero_start.map{ |n| eqn1.call(n) }
    end

    let(:eqn1_fft) do
        [
            Complex(2.65687575733752, 0), Complex(2.89490454531175, 1.05623861949702),
            Complex(4.06675544112370, 3.12057913583346), Complex(18.6206713787602, 23.4607075248439),
            Complex(-3.45289686180958, -6.69598905683325), Complex(-1.06873089727385, -3.24237581909468),
            Complex(-0.417234596452372, -2.20918291523614), Complex(-0.124107274493973, -1.69434767851828),
            Complex(0.0378858654076158, -1.37835466733456),	Complex(0.138379088467931, -1.16081779353782), 
            Complex(0.205575164207214, -0.999749708551553),	Complex(0.252948107901573, -0.874324887367059),
            Complex(0.287689057453915, -0.772962051256015),	Complex(0.313955473907545, -0.688667621886765),
            Complex(0.334301379764437, -0.616947053368878),	Complex(0.350372551635946, -0.554767426853916),
            Complex(0.363271264002680, -0.500000000000003),	Complex(0.373759669157643, -0.451101270745941),
            Complex(0.382378984239081, -0.406920911367781), Complex(0.389522294327164, -0.366581060361554),	
            Complex(0.395480610262053, -0.329397665020533),	Complex(0.400472894783644, -0.294827602762119),
            Complex(0.404666151239032, -0.262432149582308),	Complex(0.408189168792426, -0.231851121562525),
            Complex(0.411142111171973, -0.202784162749620),	Complex(0.413603316912608, -0.174976923001266),	
            Complex(0.415634187553952, -0.148210643843012),	Complex(0.417282737166011, -0.122294155186444),
            Complex(0.418586184923703, -0.0970575962472737), Complex(0.419572848332432, -0.0723473766715514),
            Complex(0.420263512367843, -0.0480220280813517), Complex(0.420672393712994, -0.0239486857952168),
            Complex(0.420807779837732, 0), Complex(0.420672393712994, 0.0239486857952168),
            Complex(0.420263512367843, 0.0480220280813517),	Complex(0.419572848332432, 0.0723473766715514),
            Complex(0.418586184923703, 0.0970575962472737),	Complex(0.417282737166011, 0.122294155186444),
            Complex(0.415634187553952, 0.148210643843012), Complex(0.413603316912608, 0.174976923001266),
            Complex(0.411142111171973, 0.202784162749620), Complex(0.408189168792426, 0.231851121562525),	
            Complex(0.404666151239032, 0.262432149582308), Complex(0.400472894783644, 0.294827602762119),	
            Complex(0.395480610262053, 0.329397665020533), Complex(0.389522294327164, 0.366581060361554),	
            Complex(0.382378984239081, 0.406920911367781), Complex(0.373759669157643, 0.451101270745941),	
            Complex(0.363271264002680, 0.500000000000003), Complex(0.350372551635946, 0.554767426853916),	
            Complex(0.334301379764437, 0.616947053368878), Complex(0.313955473907545, 0.688667621886765),	
            Complex(0.287689057453915, 0.772962051256015), Complex(0.252948107901573, 0.874324887367059),	
            Complex(0.205575164207214, 0.999749708551553), Complex(0.138379088467931, 1.16081779353782),
            Complex(0.0378858654076158, 1.37835466733456), Complex(-0.124107274493973, 1.69434767851828),	
            Complex(-0.417234596452372, 2.20918291523614), Complex(-1.06873089727385, 3.24237581909468),	
            Complex(-3.45289686180958, 6.69598905683325), Complex(18.6206713787602, -23.4607075248439),	
           Complex(4.06675544112370, -3.12057913583346), Complex(2.89490454531175, -1.05623861949702)
        ].map{ |val| Complex(val.real.round(5), val.imag.round(5)) }
    
    end

    let(:eqn1_fft_mag) do
        [
            3.34785876296257, 3.75473561177595, 5.75390597669442, 30.5229145621774,
            7.02043143754709, 2.95259736804965,	1.83205840537384, 1.32122750116733,
            1.03385280814823, 0.851675344450318, 0.726828267003766,	0.636438645418066,
            0.568281562950868, 0.515268313033905, 0.473023882323423, 0.438711206124472,
            0.410415057822793, 0.386798768523570, 0.366903076872398, 0.350023180561531,
            0.335630839678014, 0.323323475773902, 0.312790009471940, 0.303787393787232,
            0.296124168146467, 0.289648734812854, 0.284240884745626, 0.279805608557944,
            0.276268549814208, 0.273572666243734, 0.271675802784064, 0.270548974731953,
            0.270175225787320, 0.270548974731953, 0.271675802784064, 0.273572666243734,
            0.276268549814208, 0.279805608557944, 0.284240884745626, 0.289648734812854,
            0.296124168146467, 0.303787393787232, 0.312790009471940, 0.323323475773902,
            0.335630839678014, 0.350023180561531, 0.366903076872398, 0.386798768523570,
            0.410415057822793, 0.438711206124472, 0.473023882323423, 0.515268313033905,
            0.568281562950868, 0.636438645418066, 0.726828267003766, 0.851675344450318,
            1.03385280814823, 1.32122750116733, 1.83205840537384, 2.95259736804965,
            7.02043143754709, 30.5229145621774, 5.75390597669442, 3.75473561177595
        ].map{|val| val.round(5) }
    end

    let(:eqn1_fft_angle) do
        [
            0, 0.205832856814830, 0.405016366726183, 0.592503479101586, -2.37599768636378, 
            -2.21787556358963, -2.07388116496928, -1.94246899387279, -1.82188690730635,
            -1.71045138471961, -1.60666813798124, -1.50926499933668, -1.41718243613742,
            -1.32954735873465, -1.24564306589501, -1.16488100137536, -1.08677635737691,
            -1.01092786879428, -0.937001442038112, -0.864717035898347, -0.793838195490414,
            -0.724163705689000, -0.655520918619523, -0.587760395628660, -0.520751578540084,
            -0.454379265918058, -0.388540718426217,	-0.323143255068521,	-0.258102231132172,
            -0.193339310800271,	-0.128780964128635,	-0.0643571305349854, 0,	
            0.0643571305349854,	0.128780964128635, 0.193339310800271, 0.258102231132172,
            0.323143255068521, 0.388540718426217, 0.454379265918058, 0.520751578540084,	
            0.587760395628660, 0.655520918619523, 0.724163705689000, 0.793838195490414,
            0.864717035898347, 0.937001442038112, 1.01092786879428, 1.08677635737691,
            1.16488100137536, 1.24564306589501, 1.32954735873465, 1.41718243613742,
            1.50926499933668, 1.60666813798124, 1.71045138471961, 1.82188690730635,
            1.94246899387279, 2.07388116496928, 2.21787556358963, 2.37599768636378,
            -0.592503479101586, -0.405016366726183, -0.205832856814830
        ].map{ |val| val.round(5) }
    end

    let(:fft) do
        Dsp::FFT.new(time_data: data)
    end

    it "#calculate correctly calculates the fft" do 
        data = range.map{ |n| eqn1.call(n) }
        expect(Dsp::FFT.new(time_data: data).calculate.map do |val|
            val.is_a?(Complex) ? Complex(val.real.round(5), val.imag.round(5)) : val.round(5)
        end
            ).to eq(eqn1_fft)
    end

    it "#process_with window can process data through a window before fft" do
        expect(Dsp::FFT.new(time_data: data).process_with_window.map do |val|
            val.is_a?(Complex) ? Complex(val.real.round(5), val.imag.round(5)) : val.round(5)
        end
            ).to eq(false)

    end

    it "#magnitude can calculate magnitude of its values" do
        fft.calculate
        expect(fft.magnitude.map{ |val| val.round(5)}).to eq(eqn1_fft_mag)
    end

    it "#angle can calculate angle of its values" do 
        fft.calculate
        expect(fft.angle.map{ |val| val.round(5)}).to eq(eqn1_fft_angle)
    end

    it "#dB can caclulate db of its values" do
        fft.calculate
        expect(fft.dB.map{ |val| val.round(2)}).to eq(eqn1_fft_mag.map{ |val| 20 * Math.log(val,10)}.map{ |val| val.round(2)})
    end

    it "#maxima can find the top n maxima in the calculated fft" do
        e1 = range_zero_start.map{ |n| eqn3.call(n) }
        e2 = range_zero_start.map{ |n| eqn2.call(n) }
        eqn = e1.plus e2
        eqnft = Dsp::FFT.new(time_data: eqn)
        eqnft.calculate
        expect(eqnft.fft.length).to eq(64)
        expect(eqnft.maxima(4).map{ |os| os.index }.sort).to eq([4, 10, 54, 60])
    end


    it "#local_maxima can find the top n local maxima in the calculated fft" do
        e1 = range_zero_start.map{ |n| eqn3.call(n) }
        e2 = range_zero_start.map{ |n| eqn2.call(n) }
        eqn = e1.plus e2
        eqnft = Dsp::FFT.new(time_data: eqn)
        eqnft.calculate
        expect(eqnft.fft.length).to eq(64)
        expect(eqnft.local_maxima(4).map{ |os| os.index }.sort).to eq([4, 10, 54, 60])
    end

    it "#* can multiply two FTs" do
        ft_squared = fft * fft 
        expect(ft_squared.data).to eq(fft.data.times fft.data)
        expect(ft_squared.is_a? Dsp::FFT).to eq(true)
    end

    it "#multiplication of fft is the same as convolution in the time domain" do
        noise_data1 = Dsp::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 10, size: 100).data
        noise_data2 = Dsp::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 5, size: 50).data
        # noise_data1 = [1,2,3,4]
        # noise_data2 = [2,3,4,5]
        dft1 = Dsp::FFT.new(time_data: noise_data1, size: 200)
        dft2 = Dsp::FFT.new(time_data: noise_data2, size: 200)
        dftout = dft1 * dft2
        timeout = dftout.ifft
        time_real = timeout.map(&:real)
        time_imag = timeout.map(&:imaginary)
        expect(time_imag.sum < 0.0001).to equal(true)
        expect(time_real).to eq(Dsp::Functions.conv(noise_data1, noise_data2))
    end
    
end