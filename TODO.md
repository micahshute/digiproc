# TODOS

- [ ] Change FFT `data` variable to hold fft vals instead of time domain vals. 
    - [ ] Make FFT class `convolvable`  

- [ ] Make new convolution strategy to replace Brute Force (BF) strategy
- [ ] Add Gaussian distribution generator
- [ ] Add White noise generator
- [ ] Add `analytic signal` function 
    - [ ] In where? Used for bandpass signals
- [ ] Implement Analog signal, allow custom sampling rate, include nyquist freq (based on freq or bandwidth)
    - [ ] Implement quantization
    - [ ] Allow companding techniques in quantization process
- [ ] Look at using rubyvis as graphical tool instead of gruff 
- [ ] Ensure FFT class is fully disconnected from FFTStrategy (ie having to zero fill for Radix2)
    - [ ] Ensure custom strategies can be built and implemented
- [ ] Same as above for companding strategies and window strategies
- [ ] Add #process to digitalSignal and FFT which accepts a block and iterates through each item in `data`
    - [ ] Consider making this a module `processible`, which `requires_data`
- [ ] Look into using a better quantization strategy (right now mapping max <-> min to -1 <-> +1 is limited by floating point accuraccy for large ranges)
- [x] Move `#map_to` method from AnalogSignal and put it in Dsp::Functions
- [ ] Investigate changing Dsp to DSP
- [ ] Review / cleanup / investigate proper scope of methods in Dsp::Functions
    - [ ] If the `#map_to` methods are kept in Dsp::Functions, remove them from `AnalogSignal`

