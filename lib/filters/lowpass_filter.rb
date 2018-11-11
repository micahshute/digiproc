class LowpassFilter < DigitalFilter

    attr_accessor :equation
    
    def initialize(size:, window: RectangularWindow, wc: , correct: true)
        super(size: size, window: window)
        wc = wc + @window.transition_width * PI if correct
        @equation = ->(n){ 
            n == 0 ? (wc / PI) : (Math.sin(wc * n) / (PI * n)) 
        }
        ideal_filter = calculate_ideal
        @weights = self.window.values.dot ideal_filter
        @fft = Dsp::FFT.new(time_data: self.weights)
        @fft.calculate
    end
end