require 'gruff'
module Dsp::Plottable

    module Styles
        MIDNIGHT = {
            :colors => [
              '#00dae5',  #teal
              '#FF1A1A',  # red
              '#3FFC07',  # green
              '#FDD84E',  # yellow
              '#6886B4',  # blue
              '#8A6EAF',  # purple
              '#EFAA43',  # orange
              'white'
            ],
            :marker_color => '#7e7c7f',
            :font_color => '#cccccc',
            :background_colors => %w(black #2a2a2a)
          }

          SUBMARINE = {
            :colors => [
              '#FF1A1A',  # red
              '#3FFC07',  # green
              '#FDD84E',  # yellow
              '#6886B4',  # blue
              '#8A6EAF',  # purple
              '#EFAA43',  # orange
              'white'
            ],
            :marker_color => '#3d007a',
            :font_color => '#cccccc',
            :background_colors => %w(black #2a2a2a)
          }

          BLUESCALE = {
            :colors => [
              '#0b0b70', #
              '#383838', #
              '#686868', #
              '#989898', #
              '#c8c8c8', #
              '#e8e8e8', #
            ],
            :marker_color => '#aea9a9', # Grey
            :font_color => 'black',
            :background_colors => 'white'
          }
    end

    module ClassMethods


        # TODO: Below method will be plotted inside a block instead
        # of passing params to the method. Also, the logic below the 
        # yield will fix the problem of x float values not being able to
        # have corresponding labels. Lastly, it will return an instance
        # of the plot without writing it, so it can be decorated with
        # vertical lines, or any other future decorator. 

        def iplot(xsteps: 4)
            g = Gruff::Line.new('1000x1000')
            g.theme = Dsp::Plottable::Styles::BLUESCALE
            g.line_width = 2
            g.dot_radius = 0.1
            yield g 
            #must insert data :name, data_arr 
            #or dataxy :name, x_arr, y_arr

            # Go through each dataset, 
            #If there are x values, get max and min
            #If there are not, get the length of the data
            #If labels are not inserted by user, do:
            #  get range of largest dataset
            #  label at 0, 0.25*len, 0.5*len, 0.75*len, len
            return g 
        end





        def qplot(x: nil ,y: nil , data: nil, data_name: "data", xyname: "data",filename: "#{self}_plot", path: "./plots/", xsteps: 4, label_map: nil)
            raise ArgumentError.new("Either x and y or data must exist") if data.nil? and (x.nil? or y.nil?)
            data = data
            raise TypeError.new("Data must be an array, not a #{data.class}") if data and not data.is_a? Array
            raise TypeError.new("X and Y must be arrays, not #{x.class}, #{y.class}") if (!!x and !!y) and not (x.is_a?(Array) and y.is_a?(Array))
            raise ArgumentError.new("X and Y must be the same size") if (!!x and !!y) and (x.length != y.length)
            g = Gruff::Line.new('1000x1000')
            g.theme = Styles::BLUESCALE
            g.line_width = 2.5
            g.dot_radius = 0.1
            # g.minimum_x_value = 0
            g.data data_name, data if !!data
            g.dataxy xyname, x, y if !!x and !!y
            xmax = !!data ? data.length : x.max
            xmin = !!data ? 0 : x.min
            increment_label = (xmax - xmin) / xsteps.to_f
            datalength = !!data ? data.length : x.length
            increment_datapoints = (datalength.to_f / xsteps).round
            labels = {}
            for i in 0..xsteps do
                datapoint_location = i * increment_datapoints
                datapoint_location -= 1 if datapoint_location > (datalength - 1)
                label_val = label_map.nil? ? (i * increment_label).round(2) : label_map.call((i * increment_label)).round(2)
                labels[datapoint_location] = label_val
            end
            g.labels = labels
            g.show_vertical_markers = false
            yield g
            g.write(path + filename + '.png')
        end


        #TODO: Figure out a way to display a vertical line using a decorator.
        #The class below displays a line from the upper left to lower right hand corner of the plot

        # class VerticalLine

        #     attr_reader :plot, :x_value, :label, :color

        #     def initialize(plot, x_value, label = "vline", color = "white")
        #         @plot, @x_value, @label, @color = plot, x_value, label, color
        #     end

        #     def write(location)
        #         add_vertical_line
        #         puts plot.instance_variable_get(:@data).to_s
        #         plot.write(location)
        #     end

        #     private

        #     def add_vertical_line
        #         data = plot.instance_variable_get(:@data)
        #         data_cpy = data.dup
        #         data_num = data.length
        #         max_y_val = data.map{ |dataset| get_max_y(dataset) }.max
        #         min_y_val = data.map{ |dataset| get_min_y(dataset) }.min
        #         plot.dataxy label, [x_value, x_value+1], [max_y_val, min_y_val]
        #         plot.colors[data_num] = color
        #     end
    
        #     def get_max_y(arr)
        #         arr[1].max
        #     end

        #     def get_min_y(arr)
        #         arr[1].min
        #     end

        #     def has_x_values?(data)
        #         data.length == 4
        #     end
        # end

        
    end
    
    module InstanceMethods

        def plot(method:, filename: "plot_#{self.class}", path: "./", xmax: 1, xmin: 0, xsteps: 4)
            data = self.send(method)
            raise TypeError.new('Data must be an array, not a #{data.class}') if not data.is_a? Array
            g = Gruff::Line.new('1000x1000')
            g.theme = Gruff::Themes::KEYNOTE
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
end