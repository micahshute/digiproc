# Use Dsp::Probability to calculate a QAM equation and find SNR


qam_eqn = Proc.new do |db|
    peb_no = 10 ** (db / 10.0)
    pes_no = peb_no * Math.log(256,2)
    pq = Dsp::Probability.normal_q( Math.sqrt(pes_no * 3.0 / 255))
    psmo2 = (Math.sqrt(256) - 2)
    ppc1 = (1 - 2 * pq) ** 2
    ppc2 = (1 - 2 * pq) * (1 - pq)
    ppc3 = (1 - pq) ** 2
    ps = 1 - (1.0 / 256) * ((psmo2 ** 2) * ppc1 + 4 * psmo2 * ppc2 + 4 * ppc3)
    ps / Math.log(256, 2)
end

def findval(eqn, value, desired_val, step = 0.001 , tolerance = 0.000000005)
    output = eqn[value]
    if (output >= (desired_val - tolerance)) and (output <= (desired_val + tolerance))
        return value
    else
        slope = (output <=> eqn[value + tolerance])
        dir_to_output = output <=> desired_val
        next_val = value + slope * dir_to_output * step
        return findval(eqn, next_val, desired_val)
    end
end

qam = findval(qam_eqn, 25 , 0.000001)
puts "QAM Eb/No = #{qam}"