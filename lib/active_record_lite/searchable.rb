module Searchable
	def where(search_hash)
		params_set = DBConnection.execute(<<-SQL, *search_hash.values)
      SELECT *
      FROM #{table_name}
      WHERE #{q_parse(search_hash)}
		SQL

		params_set.map do |parms|
			self.new(parms)
		end
	end

	def q_parse(search_hash)
		q = ''
		search_hash.keys.each {|key| q = "#{key} = ?" }
		q
	end
end