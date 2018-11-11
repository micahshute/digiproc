require 'gruff'
class Dsp::FFT

    
    def self.calculate(time_data)
        Radix2Strategy.calculate(time_data)
    end

    def self.new_from_spectrum(data)
        time_data = Dsp::Strategies::IFFTConjugateStrategy.new(data)
        new(freq_data: data, time_data: time_data)
    end

    attr_accessor :strategy, :window, :processed_time_data, :time_data_size, :data
    attr_reader :fft, :data
    include Convolvable::InstanceMethods

    #Using size wiht a Radix2Strategy will only ensure a minimum amount of 
    #zero-padding, it will mostly likely not determine the final size of the time_data
    def initialize(strategy: Radix2Strategy, time_data: nil, size: nil, window: RectangularWindow, freq_data: nil)
        raise ArgumentError.new("Either time or frequency data must be given") if time_data.nil? and freq_data.nil?
        raise ArgumentError.new('Size must be an integer') if not size.nil? and not size.is_a?(Integer) 
        raise ArguemntError.new('Size must be greater than zero') if not size.nil? and size <= 0 
        raise ArgumentError.new('time_data must be an array') if not time_data.respond_to?(:calculate) and not time_data.is_a? Array
        
        if time_data.is_a? Array
            @time_data_size = time_data.length
            if not size.nil?
                if size <= time_data.length
                    @time_data = time_data.dup.map{ |val| val.dup }.take(size)
                else size > time_data.length
                    zero_fill = Array.new(size - time_data.length, 0)
                    @time_data = time_data.dup.map{ |val| val.dup }.concat zero_fill
                end
            else
                @time_data = time_data.dup.map{ |val| val.dup}
            end
            @strategy = strategy.new(time_data.map{ |val| val.dup})
            @window = window.new(size: time_data_size)
        else
            @time_data = time_data
            @strategy = strategy.new
            @window = window.new(size: freq_data.length)
        end
        
        @data = freq_data
    end

    def calculate
        self.strategy.data = time_data if @strategy.data.nil?
        @fft = self.strategy.calculate
        @data = @fft
    end

    def data
        calculate if @data.nil?
        @data
    end

    def time_data
        if @time_data.is_a? Array
            @time_data
        elsif @time_data.respond_to? :calculate
            @time_data = @time_data.calculate
        else
            raise TypeError.new("time_data needs to be an array or an ifft strategy, not a #{@time_data.class}")
        end
    end

    def process_with_window
        @processed_time_data = time_data.take(time_data_size) * self.window.values
        self.strategy.time_data = @processed_time_data
        @fft = self.strategy.calculate
        @data = @fft
    end

    def magnitude
        @fft.map do |f|
            f.abs
        end
    end

    def dB
        self.magnitude.map do |m|
            Math.db(m)
        end
    end

    def angle
        self.fft.map do |f|
            f.angle
        end
    end

    def real
        self.fft.map do |f|
            f.real
        end
    end

    def imaginary
        self.fft.map do |f|
            f.imaginary
        end
    end

    def maxima(num = 1)
        Dsp::DataProperties.maxima(self.magnitude, num)
    end

    def local_maxima(num = 1)
        Dsp::DataProperties.local_maxima(self.magnitude, num)
    end

    def *(obj)
        if obj.respond_to?(:data) 
            return self.class.new_from_spectrum(self.data.dot obj.data)
        elsif obj.is_a? Array 
            return self.class.new_from_specctrum(self.data.dot obj.data)
        end
    end


    #TODO: add vertical lines at transitions
    def graph_db(file_name = "fft_db")
        if @fft
            data = self.dB
            labels = {}
            for i in 0...data.length
                labels[i] = '%.2f' % (i.to_f / data.length) if i % (data.length / 5) == 0
            end
            g = Gruff::Line.new('1000x1000')
            g.title = "dB vs Normalized Frequency"
            g.x_axis_label = "Normalized Frequency"
            g.y_axis_label = "dB"
            g.y_axis_increment = 20
            g.line_width = 1
            g.dot_radius = 1
            #g.reference_lines = [{index: }, {index: }]
            # g.label_formatting = "%.2f"
            g.maximum_x_value = 1
            g.minimum_x_value = 0
            g.show_vertical_markers = true
            g.data :dB, data
            g.labels = labels
            g.write("./#{file_name}.png")
        end 
    end

    def graph_magnitude(file_name = "fft")
        if @fft
            g = Gruff::Line.new
            g.data :fft, self.magnitude
            g.write("./#{file_name}.png")
        end
    end

    def graph_time_data
        g = Gruff::Line.new
        g.data :data, @time_data
    end


end