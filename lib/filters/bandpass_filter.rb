##
# Creates a Bandpass Filter via the Windowing method. 
class Digiproc::BandpassFilter < Digiproc::DigitalFilter
    attr_accessor :equation

    ##
    # == Inputs
    # size:: [Integer] number of datapoints window should be 
    # window:: [Digiproc::WindowStrategy] desired window strategy
    # wo:: [Float] center frequency in radians
    # bw:: [Float] bandwidth in radians
    # wcl:: [Float] lower cutoff frequency in radians
    # wch:: [Float] higher cutoff frequency in radians
    # correct:: [Boolean] perform frequency corrections to make frequency points more accurate. Defaults to true
    #
    # Must have either `wo` and `bw` or `wcl` and `wch`
    #
    ## Digiproc::BandpassFilter.new(size: 1000, wo: Math::PI / 4, bw: Math::PI / 10) 

    def initialize(size:, window: Digiproc::RectangularWindow, wo: nil, bw: nil, wcl: nil , wch: nil, correct: true )

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
        @fft = Digiproc::FFT.new(time_data: self.weights)
        @fft.calculate
    end
end