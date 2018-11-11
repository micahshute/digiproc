# TODOS

- [x] Change FFT `data` variable to hold fft vals instead of time domain vals. 
    - [x] Make FFT class `convolvable`  

- [ ] Make new convolution strategy to replace Brute Force (BF) strategy
- [x] Add Gaussian distribution generator
- [ ] Add White noise generator
- [ ] Add `analytic signal` function 
    - [ ] In where? Used for bandpass signals
- [x] Implement Analog signal, allow custom sampling rate, include nyquist freq (based on freq or bandwidth)
    - [x] Implement quantization
    - [x] Allow companding techniques in quantization process
- [ ] Look at using rubyvis as graphical tool instead of gruff 
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
- [ ] Add IFFT, make FFT class multiplyable, test to ensure it equals convolution in the time domain

