# Dsp

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/dsp`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dsp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dsp

## Usage


__Limitations to be aware of__:
 - All signals must be causual -> negative values of n are not supported
 - The FFT, as of now, uses a Radix 2 algorithm. So, the overall size must be a power of 2 - any dataset is zero-filled automatically to meet this necessity. This gives you less control over the exact size if needed and may cause slower runtimes (however the radix 2 algorithm is &#1012;(nlgn)). This zero-fill _will_ increase the resolution of the FFT output, however.
 - All filter data and windows must have an even number of datapoints. If not, this will be done automatically. This is to facilitate the ability to create any type of filter using the windowing method. (Odd numbers of values can preclude certain types of filters)
 - All filters are FIR and are implemented via the windowing method. Although you can get pretty good results depending on your application, this is an older method compared to the optimal Parks-McClellan algorithm.
 - IIR Filter design is not included
 - The quantization process in Dsp::AnalogSignal maps an analog signal to -1 to 1 before quantizing the result. A floating point number is accurate up to 7 decimal places, so this process will cause unwanted ACTUAL quantization errors (not simulated quantization errors) for an amplitude range greater than $2 x 10^16$ (ie 20 Quadrillion)

This is still a work in progress. There are many usuable functions, and many that still require tuning. Functions tested in the `spec` file are very reliable.



__Run Examples__

Use ```rake examples:run[file]``` to run an example file to see how it works, ie: ```rake examples:run[binomial_distribution/dice]```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/micahshute/dsp. 

There is a long list of intended actions in the `TODO.md` file. Tests (rspec) covers many core capabilities, but more need to be written to cover the entire gem.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. That being said, negative feedback is always welcome. 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dsp project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dsp/blob/master/CODE_OF_CONDUCT.md).
