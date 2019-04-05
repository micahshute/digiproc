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


    def self.line(x = nil, y = nil, label=nil)
        LinePlot.new(x, y, label)
    end


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

        def filename(name)
            @filename = name
        end
        def title(title)
            @methods[:title] = title
        end

        def xlabel(label)
            @methods[:x_axis_label] = label
        end

        def ylabel(label)
            @methods[:y_axis_label] = label
        end

        def data_label(label)
            @dataxy.last[0] = label
        end

        def legend(*labels)
            labels.each.with_index do |l, i|
                @dataxy[i][0] = l
            end
        end

        def add_line(x, y, label="data #{@dataxy.length + 1}")
            @dataxy << [label, x, y]
        end

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

        def path(path)
            @path = path
        end

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

        def size(w,h)
            @size = "#{w}x#{h}"
        end

        def show    
            write
            file = @path + @filename + '.png'
            if windows?
                system %{cmd /c "start #{file}"}
            elsif mac?
                file_to_open = "/path/to/file.txt"
                system %{open "#{file}"}
            elsif linux?
                system %{xdg-open "#{file}"}
            end
        end

        def write
            gline = Gruff::Line.new(@size)
            @methods.each do |m, args|
                gline.send("#{m}=", args)
            end
            @dataxy.each do |dxy| 
                gline.dataxy(dxy[0], dxy[1], dxy[2]) 
            end

            @filename ||= @methods[:title]
            @filename ||= "rbPlot"
            gline.write(@path + @filename + '.png')
        end

    end
end