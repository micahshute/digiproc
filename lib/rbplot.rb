##
# Plotting API built on top of Gruff meant to mimick matplotlib
class Dsp::Rbplot

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
          '#0b0b70', #Blue
          '#981598', #Purple
          '#181000', #Dark gray
          '#B50202', #
          '#c8c8c8', #
          '#e8e8e8', #
        ],
        :marker_color => '#aea9a9', # Grey
        :font_color => 'black',
        :background_colors => 'white'
      }


    ##
    # Constuctor for a line plot instnace
    ## x = Dsp::Functions.linspace(1,100,100)
    ## y = Dsp::Probability.nrand(100)
    ## plt = Dsp::Rbplot.line(x, y, "random vals")
    def self.line(x = nil, y = nil, label=nil)
        LinePlot.new(x, y, label)
    end

    ##
    # Class for a line plot
    class LinePlot
        include Dsp::OS
        def initialize(x, y, label = "data 1")
            @methods = {
                line_width: 2.5, 
                dot_radius: 0.1,
                theme: BLUESCALE,
            }
            @dataxy = [[label, x, y]]
            @path = './'
            @filename = nil
            @size = '1000x1000'
            self.xsteps(5)
        end

        ##
        # sets filename for the image to be written
        # downcases, strips, and replaces spaces with dashes
        def filename(name)
            @filename = name.downcase.strip.gsub(' ', '-')
        end
        ##
        #Sets title for the graph
        ## plt.title('Plot Title')
        def title(title)
            @methods[:title] = title
        end

        ##
        # Sets the x label:
        ## plt.xlabel('time')
        def xlabel(label)
            @methods[:x_axis_label] = label
        end

        ##
        # Sets the y label
        ## plt.ylabel('y axis')
        def ylabel(label)
            @methods[:y_axis_label] = label
        end

        ##
        # Sets data label for the last inputted line data
        ## plt.data_label('Set 3')
        def data_label(label)
            @dataxy.last[0] = label
        end

        ##
        # Sets the labels for each line entered (variable array input)
        ## plt.legend("Data 1", "Data 2")
        def legend(*labels)
            labels.each.with_index do |l, i|
                @dataxy[i][0] = l
            end
        end

        ##
        # Add another line to the plot
        # y2 = Dsp::Probability.nrand(100)
        ## plt.add_line(x, y2, "Data 2")
        def add_line(x, y, label="data #{@dataxy.length + 1}")
            @dataxy << [label, x, y]
        end

        ##
        # Sets the number of labels on the x axis
        ## plt.xsteps(5)
        def xsteps(steps)
            len = @dataxy.first[1].length
            steps = len if(steps >= len)
            labels = {}
            every = (len.to_f / steps).floor
            for i in 0..steps do
                index = i == 0 ? 0 : (i * every) - 1
                labels[i * every] = @dataxy.first[1][index].round(2)
            end
            @methods[:labels] = labels
        end

        ##
        # Sets the path where the image will be written
        # Defaults to "./"
        ## plt.path("./")
        def path(path)
            @path = path
        end

        ##
        # Sets the theme of the graph
        # Accepts :dark, :light, or :deep
        ## plt.theme(:dark)
        def theme(theme)
            case theme
            when :dark
                @methods[:theme] = MIDNIGHT
            when :deep
                @methods[:theme] = SUBMARINE
            when :light
                @methods[:theme] = BLUESCALE
            else
                throw ArgumentError.new('Not a valid theme')
            end
        end

        ##
        # Set size of the graph in pixels. Takes two integers
        ## plt.size(2000, 2000). Defaults upon initialization to 1000,1000
        def size(w,h)
            @size = "#{w}x#{h}"
        end

        ##
        # Writes the image and opens it with the default program depending on the os
        ## plt.show
        def show    
            write
            file = @path + @filename + '.png'
            if windows?
                system %{cmd /c "start #{file}"}
            elsif mac?
                file_to_open = "/path/to/file.txt"
                system %{open "#{file}"}
            elsif linux?
                begin 
                    system %{xdg-open "#{file}"}
                    system %{cmd.exe /c "start #{file}"}
                rescue 
                    system %{cmd.exe /c "start #{file}"}
                end
            end
        end

        ##
        # Writes the image to the saved path, does not open it
        ## plt.write
        def write
            gline = Gruff::Line.new(@size)
            @methods.each do |m, args|
                gline.send("#{m}=", args)
            end
            @dataxy.each do |dxy| 
                gline.dataxy(dxy[0], dxy[1], dxy[2]) 
            end

            @filename ||= filename(@methods[:title])
            @filename ||= "rbPlot"
            gline.write(@path + @filename + '.png')
        end

    end
end