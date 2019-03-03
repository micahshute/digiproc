plt = Dsp::QuickPlot
fns = Dsp::Functions
prob = Dsp::Probability
norm_dist = Dsp::Probability::RealizedGaussianDistribution
factory = Dsp::Factories::FilterFactory
e = Math::E
pi = Math::PI

#-------------------------------------------------------------
#PROBLEM 1
#---------------------------------------------------------------
# Create "white" Gaussian noise, 0 mean
# dist = norm_dist.new(mean: 0, stddev: 1, size: 16384)

# # Create a bandpass filter, make FT dimensions match
# bpfilter = factory.filter_for(type: "bandpass", wo: Math::PI / 2, bw: Math::PI / 5, transition_width: 0.0001, stopband_attenuation: 80)
# filter_dft = Dsp::FFT.new(time_data: bpfilter.weights, size: 16384 * 4)

# # Get FT of White noise, calculate No 
# dist_fft = Dsp::FFT.new(time_data: dist.data, size: 16384 * 4)
# n_o = 2 *  (dist_fft.magnitude.map{ |val| val ** 2}.sum.to_f / dist_fft.data.length)

# # Multiply freq domain of noise and filter to get output spectra
# # Calculate output energy
# filter_out = dist_fft * filter_dft
# total_noise_out = filter_out.magnitude.map{ |val| (val ** 2) * (1.0/ (4 * 16384)) }.sum 
# time_data_out = fns.ifft(filter_out.data).map(&:real)
# bw = 1.0 / 10

# puts "Normal Dist. Input \n\tMean:#{prob.mean(dist.data)}, Stddev: #{prob.stddev(dist.data)}"
# puts "No = #{n_o}"
# puts "Total Noise Energy Out: #{total_noise_out}"
# puts "Output: \n\tMean: #{prob.mean(time_data_out)}, Stddev: #{prob.stddev(time_data_out)}"
# puts "Calculated Noise Energy Out: #{ n_o * bw}"

# f =  fns.linspace(0,1,16384)

# plt.plot(x: f, y: filter_dft.dB, title: "Bandpass Filter")
# plt.plot(x: f, y: dist_fft.magnitude, title: "White Noise Spectra" )
# plt.plot(x: f, y: filter_out.magnitude, title: "White Noise Mag Out of BP Filter", y_label: "Magnitude")
# plt.plot(x: f, y: filter_out.dB, title: "White Noise dB Out of BP Filter", y_label: "dB")

#--------------------------------------------------------------
#PROBLEM 2
#--------------------------------------------------------------

# #Generate white noise
# noise = norm_dist.new(mean: 0, stddev: 1, size: 4096)
# #Generate signal
# sys = DigitalSignal.new(data: [1,-2,1])

# #Put noise through system, autocorrelate output
# output = sys.ds_conv noise
# output_autocorrelation = output.acorr

# n_o = 2 * noise.data.dot(noise.data)
# #Display results
# expanded_sys = Dsp::FFT.new(time_data: sys.data, size: 4096)
# calculated_system_equation = ->(w){ (1 - 2 * e ** (Complex(0,-1) * w) + e ** (Complex(0,-2) * w)).abs}

# # f = fns.linspace(0,1,4096)
# # w = fns.linspace(0,2*pi, 4096)
# # calculated_system_spectra = w.map{|value| calculated_system_equation.call(value)}
# # plt.plot(x: f, y: expanded_sys.magnitude, title: "System Spectra")
# # plt.plot(x: f, y: (Dsp::FFT.new(time_data: noise.data) * expanded_sys).magnitude, title: "Output Spectra")
# # plt.plot(x: w, y: calculated_system_spectra, title: "Expected System Spectra", data_name: "1 - 2exp(jw) + exp(j2w)")
# # plt.plot(data: output_autocorrelation[4093..4101], title: "Autocorrelation of output")

# puts n_o
# puts "Input noise mean: #{prob.mean(noise.data)}"
# puts "Output mean: #{prob.mean(output.data)}"


#----------------------------------------------------
#PROBLEM 3
#----------------------------------------------------

# eqn = ->(t){ (t >= 0 and t <= 0.1) ? (100 * t * Math.cos(2*Math::PI*2.5*t)) : 0 }
# analog_signal = Dsp::AnalogSignal.new(eqn: eqn, sample_rate: 0.0001, size: 10000)
# digital_signal = analog_signal.to_ds

# sample_time_zero = digital_signal.data.dot digital_signal.data
# samples_per_unit = 1.0 / analog_signal.sample_rate
# puts "Output at t = tmax: #{sample_time_zero / samples_per_unit}"

#---------------------------------------------------------
#PROBLEM 4
#---------------------------------------------------------
# a_vals = [0,-0.25, 0.25, 0]
# stddev_vals = [3,1,0.5, 0.5]

# for i in 0...a_vals.length do
#     a = a_vals[i]
#     stddev = stddev_vals[i]
#     tgauss = Dsp::Probability::TheoreticalGaussianDistribution.new(mean: 0, stddev: stddev)
#     #Build system from a gaussian distribution
#     p_b = 0.5 * (0.25 * tgauss.cdf(a - 0.5) + 0.5 * tgauss.cdf(a - 1) + 0.25 * tgauss.cdf(a - 1.5)) + 0.5 * (0.25 * tgauss.q(a + 1.5) + 0.5 * tgauss.q(a + 1) + 0.25 * tgauss.q(a + 0.5))
#     #Test with simplified equation
#     pb_zero_test = 0.25 * prob.normal_q(0.5 / stddev) + 0.5 * prob.normal_q(1.0 / stddev) + 0.25 * prob.normal_q(1.5 / stddev)
#     pb_test = (1.0 / 8) * (prob.normal_q((0.5 - a) / stddev) + prob.normal_q((0.5 + a) / stddev)) + 0.25 * (prob.normal_q((1.0 - a) / stddev) + prob.normal_q((a + 1.0) / stddev)) + (1.0/8) * (prob.normal_q((1.5 - a) / stddev) + prob.normal_q((a + 1.5) / stddev))
#     puts "Test for A = #{a}, Standard Deviation = #{stddev}"
#     puts "Original Eqn: #{p_b.round(4)}, Simplified Eqn: #{pb_test.round(4)}"
#     puts "Equation for a = 0 reads #{pb_zero_test.round(4)}" if a == 0 
#     p_b.round(4) == pb_test.round(4) ? puts("Match at #{(p_b * 100).round(2)}%!") : puts("Equations do not match")
#     puts "-----------------------------------------------------"
# end

# #Simulation

# def get_im(rand_gen)
#     r = 1 - rand_gen.rand
#     if r < 0.25
#         return 0.5
#     elsif r < 0.5
#         return 0.5
#     else
#         return 0
#     end
# end 

# def get_am(rand_gen)
#     rand_gen.rand(2) == 0 ? -1 : 1
# end



# r = Random.new
# a = 0
# stddev = 0.5
# total_runs = 500000
# error_count = 0
# normal_gen = prob.normal_random_generator(0, stddev)
# total_runs.times do 
#     am, nm, im = get_am(r), normal_gen.rand, get_im(r)
#     ym = am + nm + im
#     error_count += 1 if (am == 1 and ym < a) or (am == -1 and ym > a)
# end
# puts "Simulation for A = #{a} and Standard Deviation = #{stddev}"
# puts "Total erros: #{error_count} out of #{total_runs} trials."
# puts "Pb = #{((error_count.to_f / total_runs) * 100.0).round(2)}%"

# ------------------------------------------------------------------------------
# PROBLEM 5
# ------------------------------------------------------------------------------
# r = 10
# c = 10
# impulse_resp = ->(t){ (1.0 / (10*10)) * Math::E ** (-t / (10 * 10).to_f) } 

# noise = norm_dist.new(mean: 0, stddev: 10, size: 50000)

# rc_circuit = DigitalSignal.new_from_eqn(eqn: impulse_resp, size: noise.size)

# noise_signal = DigitalSignal.new(data: noise.data)
# output_spectra = rc_circuit.fft(noise.data.length * 2) * noise_signal.fft(noise.data.length * 2)

# output_signal = output_spectra.ifft.map(&:real).take(noise.size - 1)
# variance = prob.variance(output_signal)
# puts "Varaince for RC = #{100} and Stddev: #{noise.stddev}, Variance = #{variance.round(2)}"


# total_rolls = 5000000
# diceProb = Random.new
# rolls = []
# total_rolls.times do
#     roll_of_6 = []
#     5.times do 
#         roll_of_6 << (diceProb.rand(6) + 1)
#     end
#     rolls << roll_of_6
# end

# roll_3_of_a_kind = 0


# for roll in rolls do 
#     roll_hash = {}
#     for die in roll do 
#         if roll_hash[die]
#             roll_hash[die] += 1
#         else
#             roll_hash[die] = 1
#         end
#     end
#     if roll_hash.values.any?{ |r| r >= 3}
#         roll_3_of_a_kind += 1
#     end
# end

# puts roll_3_of_a_kind
# puts "#{roll_3_of_a_kind / total_rolls.to_f}"

def get_individual_scores(rolls)
    score = 0
    remaining = rolls.values.sum

    rolls.each do |die_num, num_rolls|
        if die_num == 1
            score += (100 * num_rolls)
            remaining -= num_rolls
        elsif die_num == 5
            score += (50 * num_rolls)
            remaining -= num_rolls
        end
    end
    puts "HELP REMAINING IS NIL #{rolls.values}" if remaining.nil?
    return [score, remaining]
end

def remove_if_val_is(val, hash)
    ret_hash = {}
    hash.each do |k,v|
        ret_hash[k] = v unless v == val
    end
    ret_hash
end

def rand_choice
    r = Random.new.rand(2)
    if r == 1
        return 3
    else
        return 3
    end
end

def roll(num_of_dice, prob)
    rolls = []
    num_of_dice.times do 
        rolls << (prob.rand(6) + 1)
    end
    rolls
end

total_rolls = 100000



def turn(leftover_score = 0, num_of_dice = 6, diceProb = Random.new)
    total_score = leftover_score
    my_roll = roll(num_of_dice, diceProb)
    score, leftover_dice = eval_score(my_roll)
    leftover_dice = 6 if leftover_dice == 0
    if leftover_dice <= rand_choice and score > 0
        return [score + total_score, leftover_dice]
    elsif score == 0
        return [0, leftover_dice]
    else
        # binding.pry if leftover_dice.nil?
        return turn(score + total_score, leftover_dice, diceProb)
    end
end

def eval_score(curr_roll)
    score = 0;
    roll_hash = {}
    for die in curr_roll do 
        if roll_hash[die]
            roll_hash[die] += 1
        else
            roll_hash[die] = 1
        end
    end
    if roll_hash.values.include?(6)
        score += 2000;
        return [score, 0]
    elsif roll_hash.values.include?(5)
        score += 1500
        leftover = remove_if_val_is(5, roll_hash)
        score_add, leftover_dice = get_individual_scores(leftover)
        score += score_add 
        return [score, leftover_dice]
    elsif roll_hash.values.include?(4)
        if roll_hash.values.include?(2)
            score += 2000
            return [score, 0]
        else
            score += 1000
            leftover = remove_if_val_is(4, roll_hash)
            score_add, leftover_dice = get_individual_scores(leftover)
            score += score_add
            return [score, leftover_dice]
        end
    elsif roll_hash.values.include?(3)
        if roll_hash.size == 2
            score += 2500
            return [score, 0]
        else
            if roll_hash[1] == 3
            elsif roll_hash[2] == 3
                score += 200
            elsif roll_hash[3] == 3
                score += 300
            elsif roll_hash[4] == 3
                score += 400
            elsif roll_hash[5] == 3
                score += 500
            elsif roll_hash[6] == 3
                score += 600
            end

            leftover = remove_if_val_is(3, roll_hash)
            score_add, leftover_dice = get_individual_scores(leftover)
            score += score_add
            return [score, leftover_dice]
        end
    else
        score_add, leftover_dice = get_individual_scores(roll_hash)
        score += score_add
        return [score, leftover_dice]
    end
end

total_score = 0
total_dice_leftover = 0
total_rolls.times do
    score, leftover_dice = turn
    total_score += score
    total_dice_leftover += leftover_dice
end


puts "#{total_score / total_rolls.to_f} avg score"
puts "#{total_dice_leftover / total_rolls.to_f} avg number of dice leftover"