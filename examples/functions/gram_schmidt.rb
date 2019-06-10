#GramSchmidtOrgonormalize calculates orthogonal vectors if possible
# translate_center_to_origin centeres points around the origin

messages = [[1,1], [1,-1], [-1,1]]
output_vectors = Digiproc::Strategies::GramSchmidtOrthonormalize.new(messages).output
puts output_vectors.to_s
# Therefore, this signal cannot be reprisented in 3-D Space

#Minimize energy in the 2-D reprisentation
puts Digiproc::Functions.translate_center_to_origin([[1,1],[1,-1],[-1,1]]).to_s