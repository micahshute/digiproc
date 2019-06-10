# Use gruff directly
g = Gruff::Line.new('1000x1000')
distr = Digiproc::Probability::GaussianDistribution.new(mean: 0, stddev: 3, size: 100)
g.data("Random data", distr.data)
g.write('./examples/quickplot/direct_gruff.png')

path = "./examples/quickplot/"


# Using QuickPlot

plt = Digiproc::QuickPlot
plt.plot(title: "Random data QuickPlot", data: distr.data, path: path, data_name: "Random distr.")
plt.plot(title: "Random data QuickPlot, dark", data: distr.data, path: path, x_label: "x axis", y_label: "y axis",dark: true)





# Using Plottable Module inside a class

    # Big advantage of not using QuickPlot is the ability to use xsteps as a parameter which specifies the label
    # interval on the x axis of the plot
class PlottableClass 

    extend Digiproc::Plottable::ClassMethods
    include Digiproc::Plottable::InstanceMethods

    def initialize(distr)
        @distr = distr
    end

    def data
        return @distr.data
    end

end

plot = PlottableClass

plot.qplot(data: distr.data, data_name: "Random distribution",xsteps: 10, path: path) do |g|
    g.title = "Random Data Plottable qPlot"
    g.x_axis_label = "x axis"
    g.y_axis_label = "y axis"
end

plot_instance = PlottableClass.new(distr)

# Instnace Methods includes qplot which is the same as above
# plot used below should be renamed to fftPlot() - it was created to plot
# a Discrete Fourier Transform - the x axis goes from 0 to 1 regardless of 
# points in the dataset to correspond to normalized frequency in a DFT plot.

plot_instance.plot(method: :data, xsteps: 10, path: path) do |g|
    g.title = "Random Data from Instance Method"
    g.x_axis_label = "x axis"
    g.y_axis_label = 'y axis'
end


## You can use Digiproc::Plottable class methods as well: (TODO)



## Using Rbplot

x = Digiproc::Functions.linspace(1,100,100)
y1 = Digiproc::Probability.nrand(100)
y2 = Digiproc::Probability.nrand(100)

plt = Digiproc::Rbplot.line(x,y1)
plt.size(2000,2000)
plt.title('Test title')
plt.xlabel('x axis')
plt.ylabel('y axis')
plt.xsteps(10)
plt.add_line(x, y2)
plt.add_line(x,x.map{ |a| a / 100})
plt.theme(:light)
plt.legend('set1', 'set2', 'set3')
plt.show
plt.title('Test title dark')
plt.theme(:dark)
plt.show

