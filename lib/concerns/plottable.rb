require 'gruff'
module Dsp::Plottable

    module ClassMethods
        def qplot(x: nil ,y: nil , data: nil, filename: "#{self}_plot", path: "./plots/", xsteps: 4)
            raise ArgumentError.new("Either x and y or data must exist") if data.nil? and (x.nil? or y.nil?)
            data = data
            raise TypeError.new("Data must be an array, not a #{data.class}") if data and not data.is_a? Array
            raise TypeError.new("X and Y must be arrays, not #{x.class}, #{y.class}") if (!!x and !!y) and not (x.is_a?(Array) and y.is_a?(Array))
            raise ArgumentError.new("X and Y must be the same size") if (!!x and !!y) and (x.length != y.length)
            g = Gruff::Line.new('1000x1000')
            g.line_width = 1
            g.dot_radius = 1
            # g.minimum_x_value = 0
            g.data :data, data if !!data
            g.dataxy :xydata, x, y if !!x and !!y
            xmax = !!data ? data.length : x.max
            xmin = !!data ? 0 : x.min
            increment_label = (xmax - xmin) / xsteps.to_f
            datalength = !!data ? data.length : x.length
            increment_datapoints = (datalength.to_f / xsteps).round
            labels = {}
            for i in 0..xsteps do
                datapoint_location = i * increment_datapoints
                datapoint_location -= 1 if datapoint_location > (datalength - 1)
                labels[datapoint_location] = (i * increment_label).round(2)
            end
            g.labels = labels
            g.show_vertical_markers = true
            yield g
            g.write(path + filename + '.png')
        end
    end
    

    def plot(method:, filename: "plot_#{self.class}", path: "./", xmax: 1, xmin: 0, xsteps: 4)
        data = self.send(method)
        raise TypeError.new('Data must be an array, not a #{data.class}') if not data.is_a? Array
        g = Gruff::Line.new('1000x1000')
        g.line_width = 1
        g.dot_radius = 1
        g.minimum_x_value = 0
        g.data method, data
        increment_label = (xmax - xmin) / xsteps.to_f
        increment_datapoints = (data.length.to_f / xsteps).round
        labels = {}
        for i in 0..xsteps do
            datapoint_location = i * increment_datapoints
            datapoint_location -= 1 if datapoint_location > (data.length - 1)
            labels[datapoint_location] = (i * increment_label).round(2)
        end
        g.labels = labels
        g.show_vertical_markers = true
        yield g
        g.write(path + filename + '.png')
    end

end