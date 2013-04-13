#require_relative './db_connection'
#require_relative './mass_object'
require_relative './searchable'
require_relative './associatable'

class SQLObject < MassObject
  extend Searchable
  extend Associatable

  def self.set_table_name(name)
    @table_name = name
  end

  def self.table_name
    @table_name
  end

  def self.all
    params_set = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{table_name}
    SQL

    parse_all(params_set)
  end

  def self.find(id)
    params = DBConnection.execute(<<-SQL, id)
      SELECT *
      FROM #{table_name}
      WHERE id = ?
    SQL
    
    self.new(params[0])
  end

  def save
    if self.id.nil? 
      self.create    
    else
      self.update  
    end  
  end

  private
  
  def update
    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE #{self.class.table_name} SET #{set_names} WHERE id = ?
    SQL
  end

  def create
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO #{self.class.table_name} (#{attribute_names}) VALUES (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
    self
  end
 
  def attribute_values
    self.class.attributes.map {|att| self.send("#{att}") }
  end

  def question_marks
    ['?'] * self.class.attributes.size * ", "
  end

  def attribute_names
    self.class.attributes.map {|att| att.to_s } * ", "
  end

  def set_names
    self.class.attributes.map {|att| "#{att.to_s} = ?" } * ", "
  end
end