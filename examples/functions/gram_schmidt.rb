messages = [[1,1], [1,-1], [-1,1]]
output_vectors = Dsp::Strategies::GramSchmidtOrthonormalize.new(messages).output
puts output_vectors.to_s
# Therefore, this signal cannot be reprisented in 3-D Space

#Minimize energy in the 2-D reprisentation
puts Dsp::Functions.translate_center_to_origin([[1,1],[1,-1],[-1,1]]).to_s