class Dsp::FFT
    
    def self.calculate(data)
        Radix2Strategy.calculate(data)
    end

    attr_accessor :strategy, :data, :fft, :window, :processed_data, :data_size

    #Using size wiht a Radix2Strategy will only ensure a minimum amount of 
    #zero-padding, it will mostly likely not determine the final size of the data
    def initialize(strategy: Radix2Strategy, data: , size: nil, window: nil)
        raise ArgumentError.new('Size must be an integer') if not size.nil? and not size.is_a?(Integer) 
        raise ArguemntError.new('Size must be greater than zero') if not size.nil? and size <= 0 
        raise ArgumentError.new('Data must be an array') if not data.is_a? Array
        @data_size = data.length
        if not size.nil?
            if size <= data.length
                @data = data.take(size)
            else size > data.length
                zero_fill = Array.new(size - data.length, 0)
                @data = data.concat zero_fill
            end
        else
            @data = data
        end

        @strategy = strategy.new(data: data)
        #@window = window.new(size: data_size)
    end

    def calculate
       @fft = self.strategy.calculate
    end

    def process_with_window
        @processed_data = data.take(data_size) * self.window.values
        self.strategy.data = @processed_data
        @fft = self.strategy.calculate
    end

    def magnitude
        @fft.map do |f|
            f.abs
        end
    end

    def dB
        self.magnitude.map do |m|
            20 * Math.log(m, 10)
        end
    end

    def largest_db_maxima(num)
        data = self.dB
        rising = (data[1] - data[0]) > 0
        all_maxima = []
        maxima = []
        maxima << {0 => data[0]} && all_maxima << data[0] if not rising
        for i in 2...data.length / 2 do
            if rising
                if data[i] < data[i-1]
                    last_peak = all_maxima.last.nil? ? -1 * Float::INFINITY : all_maxima.last
                    all_maxima << data[i - 1]
                    maxima << {i => data[i - 1]} if data[i - 1] > last_peak && maxima.length < num
                    rising = false
                end
            else
                if data[i] > data[i-1]
                    rising = true
                end
            end
        end
        maxima
    end

    def local_db_maxima(num)
        data = self.dB
        rising = (data[1] - data[0]) > 0
        maxima = []
        maxima << {0 => data[0]} if not rising
        for i in 2...data.length do
            if rising
                if data[i] < data[i-1]
                    maxima << {i => data[i]}
                    maxima.sort!{ |a,b| a.values.first <=> b.values.first }
                    maxima.shift if maxima.length > num
                    rising = false
                end
            else
                if data[i] > data[i-1]
                    rising = true
                end
            end
        end
        maxima
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

    def graph_data
        g = Gruff::Line.new
        g.data :data, @data
    end


end