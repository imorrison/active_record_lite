require 'active_support/core_ext/object/try'
require 'active_support/inflector'

class Params
  attr_reader :joined_model_name, :foreign_key, :primary_key

  def other_class
    "#{joined_model_name}".constantize
  end

  def other_table
    other_class.table_name
  end
end

class BelongsToParams < Params
  def initialize(name, params)
    @joined_model_name =  params[:class_name] || name.to_s.camelcase

    @foreign_key = if params[:foreign_key]
        params[:foreign_key]
       else 
        "#{name}_id".to_sym
       end

    @primary_key = params[:primary_key] || :id
  end

  def type
    :belongs_to
  end
end

class HasManyParams < Params
  def initialize(name, params)
    @joined_model_name =  params[:class_name] || name.to_s.singularize.camelcase

    @foreign_key = if params[:foreign_key]
        params[:foreign_key]
       else 
        "#{name.underscore}_id".to_sym
       end

    @primary_key = params[:primary_key] || :id
  end

  def type
    :has_many
  end
end


module Associatable
  def assoc_params
    @assoc_params ||= {}
    @assoc_params
  end

	def belongs_to(other_model, params = {})
    association = BelongsToParams.new(other_model, params)
    assoc_params[other_model] = association

	  define_method(other_model) do
      
      params_set = DBConnection.execute(<<-SQL, self.send(association.foreign_key))
        SELECT *
        FROM #{association.joined_model_name}s
        WHERE #{association.joined_model_name}s.#{association.primary_key} = ?
      SQL

      association.other_class.parse_all(params_set)
	  end
	end

	def has_many(other_model, params = {})
    association = HasManyParams.new(other_model, params)
    assoc_params[other_model] = association

		define_method(other_model) do 

      params_set = DBConnection.execute(<<-SQL, self.send(association.primary_key))
        SELECT *
        FROM #{association.joined_model_name}s
        WHERE #{association.joined_model_name}s.#{association.foreign_key} = ?
      SQL

      association.other_class.parse_all(params_set)
		end
	end

	def has_one_through(other_model, join, other_model2)
    define_method(other_model) do 
      association1 = self.class.assoc_params[join]
      association2 = association1.other_class.assoc_params[other_model2]

      if (association1.type == :belongs_to) && (association2 .type == :belongs_to)
        p_key = self.send(association1.foreign_key)

        params_set = DBConnection.execute(<<-SQL, p_key)
          SELECT #{association2.joined_model_name}s.*
          FROM #{association1.joined_model_name}s
          JOIN #{association2.joined_model_name}s
          ON  #{association1.joined_model_name}s.#{association2.foreign_key} = 
              #{association2.joined_model_name}s.#{association2.primary_key}
          WHERE #{association1.joined_model_name}s.#{association1.primary_key} = ?
        SQL

        association2.other_class.parse_all(params_set)
      end
    end
	end
end












