require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = 'CREATE TABLE students (name TEXT, grade INTEGER);'
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 'DROP TABLE students'
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = 'INSERT INTO students (name, grade) VALUES (?, ?);'
      DB[:conn].execute(sql, self.name, self.grade)
      #assigns the id attribute of the object after insertion into db
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = 'SELECT * FROM students WHERE name=?;'
    student = DB[:conn].execute(sql,name).flatten
    Student.new_from_db(student)
  end

  def update
    sql = 'UPDATE students SET name=?, grade=? WHERE id=?;'
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
