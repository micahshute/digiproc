class Dsp::Strategies::GramSchmidtOrthonormalize

    attr_reader :original_matrix, :orthonormalized_matrix

    #requires a 2D array 
    def initialize(matrix)
        @original_vectors = matrix
        # if matrix.is_a? Array
        #     matrix = Vector.elements(matrix)
        # end
        vector_matrix = matrix.map { |vector| vector.is_a?(Array) ? Vector.elements(vector) : vector }
        @orthonormalized_matrix = gram_schmidt(vector_matrix)
    end

    def output
        @orthonormalized_matrix.map{|vector| vector.to_a } 
    end

    private

    def gram_schmidt(matrix)
        u = []
        u << normalize_vector(matrix.first)
        for i in 1...matrix.length do 
            u << matrix[i]
            for j in 0...i
                u[i] = u[i] - u[i].project_onto(u[j])
                # puts u.last.to_s if i == matrix.length - 1
            end
            u[i] = normalize_vector(u[i])
        end
        return u
    end

    def normalize_vector(vector)
        begin
           vector.normalize
        rescue Vector::ZeroVectorError
            vector
        end
    end

end