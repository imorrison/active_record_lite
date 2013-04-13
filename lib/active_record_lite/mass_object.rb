class MassObject
  def self.parse_all(results_array)
  	results_array.map {|params| self.new(params) }
  end

	def self.set_attrs(*attrs)
    @attributes = attrs
    attr_accessor(*attrs)
	end

	def self.attributes
		@attributes
	end

	def initialize(params)
		params.each do |attr_name, value|
      if self.class.attributes.include?(attr_name.to_sym)
        self.send("#{attr_name}=", value)
      else
        raise 'Mass Assignment Error'
      end
		end
	end
end