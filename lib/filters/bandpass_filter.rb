##
# Creates a Bandpass Filter via teh Windowing method. 
class Dsp::BandpassFilter < Dsp::DigitalFilter
    attr_accessor :equation

    def initialize(size:, window: RectangularWindow, wo: nil, bw: nil, wcl: nil , wch: nil, correct: true )

        super(size: size, window: window)

        if !!wo && !!bw
            bw += @window.transition_width * 2 * PI if correct
            wcl = wo - bw / 2.0
            wch = wo + bw / 2.0
        else
            raise ArgumentError.new("You must provide either bandwidth and center freq or frequency bands") if wcl.nil? or wch.nil? 
            wcl -= @window.transition_width * PI if correct
            wch += @window.transition_width * PI if correct
            bw = wch - wcl
            wo = (wch + wcl) / 2.0
        end
        @equation = ->(n){ 
            n == 0 ?  bw / PI : ((Math.sin(bw * n / 2.0)) / (PI * n)) * (2.0 * Math.cos(n * wo))
        }
        ideal_filter = calculate_ideal
        @weights = self.window.values.times ideal_filter
        @fft = Dsp::FFT.new(time_data: self.weights)
        @fft.calculate
    end
end