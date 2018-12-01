messages = [[1,1], [1,-1], [-1,1]]
output_vectors = Dsp::Strategies::GramSchmidtOrthonormalize.new(messages).output
puts output_vectors.to_s