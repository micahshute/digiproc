# TODOS

- [x] Change FFT `data` variable to hold fft vals instead of time domain vals. 
    - [x] Make FFT class `convolvable`  

- [x] Make new convolution strategy to replace Brute Force (BF) strategy
    - [ ] This is what the FFT is for -> So, instead, clean up the FFT to allow ease of multiplying 2 together at the length necessary to ensure convolution signal can be fully regained (ie FFT sizes are length that convolution would be (ie data1.length + data2.length - 1))
    - [ ] Figure out how to deal with ifft having very small imaginary values
    - [ ] Figure out how to deal with zero padding from Radix2 strategy in outputs. 
- [x] Add Gaussian distribution generator
- [ ] Add White noise generator
- [ ] Add `analytic signal` function 
    - [ ] In where? Used for bandpass signals
- [x] Implement Analog signal, allow custom sampling rate, include nyquist freq (based on freq or bandwidth)
    - [x] Implement quantization
    - [x] Allow companding techniques in quantization process
- [x] Look at using another graphical tool instead of gruff 
    - [x] Sticking with gruff for now
- [x] Ensure FFT class is fully disconnected from FFTStrategy (ie having to zero fill for Radix2)
    - [x] Ensure custom strategies can be built and implemented
- [x] Same as above for companding strategies and window strategies
- [x] Add #process to digitalSignal and FFT which accepts a block and iterates through each item in `data`
    - [ ] Consider making this a module `processible`, which `requires_data`
- [x] Look into using a better quantization strategy (right now mapping max <-> min to -1 <-> +1 is limited by floating point accuraccy for large ranges)
- [x] Move `#map_to` method from AnalogSignal and put it in Dsp::Functions
- [ ] Investigate changing Dsp to DSP
- [ ] Review / cleanup / investigate proper scope of methods in Dsp::Functions
    - [ ] If the `#map_to` methods are kept in Dsp::Functions, remove them from `AnalogSignal`
- [x] Add IFFT, make FFT class multiplyable, 
- [ ] test to ensure FFT multiplication equals convolution in the time domain
- [ ] Add Decorators to Dsp::QuickPlot to allow vertical lines being added, and maybe color schemes too 
- [ ] Make an alternative name to `dot` which is confusing because it is not the dot product (it does not sum at the end)
- [ ] Add power_spectral_density, etc to FourierTransformable module
- [ ] Figure out why convolution in matlab runs as slow as here, but cross-correlation is much faster
- [ ] Make transition_width and bandwidth, wo, etc consistant in the filter part of the project (ie right now some are normalized frequencies from 0 to 1 and some are normalized frequencies in radians)
- [ ] Ensure both Arrays and Vectors are supported for all `data` properties
- [ ] Dsp::AnalogSignal => sample_rate: to sample_interval:

