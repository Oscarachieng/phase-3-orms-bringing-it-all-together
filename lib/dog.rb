
class Dog
    attr_accessor :name, :breed, :id
    #initlize method for the attributes
    def initialize (name:,breed:, id:nil) 
        @id = id
        @name = name
        @breed = breed
    end
    # class method to create dogs table
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXITS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        SQL
        DB[:conn].execute(sql)
    end
    # #class Method to drop dogs table
    def self.drop_table
        DB[:conn].execute("DROP TABLE IF EXISTS dog")
    end
    #instance method to save a dog
    def save
        DB[:conn].execute("INSERT INTO dogs (name,breed) VaALUES (?,?)", self.name,self.breed)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
        self
    end

    #class method self.create
    def self.create (name:, breed:)
        new_dog = Dog.new(name: name, breed: breed)
        new_dog.save
    end
    #class method to handle response from the database
    def self.new_from_db (dog_row)
        new_dog_from_db = Dog.new(id: dog_row[0], name: dog_row[1], breed:dog_row[2])
    end

    #class to list all the dogs from our dogs tabe
    def self.all 
        DB[:conn].execute("SELECT * FROM dogs")
    end

    #class method to find the dog by name
    def self.find_dog_by_name (name)
        searched_dog = DB[:conn].execute("SELECT * FROM dogs WHERE name IS ? LIMIT 1", name)
        searched_dog.map do |dog|
            self.new_from_db(dog)
        end
    end
    #class method to find dog by id
    def self.find_dog_by_id (id)
       dog_by_id = DB[:conn].execute("SELECT * FROM dogs WHERE id IS ?", id)
       dog_by_id.map do |dog|
        self.new_from_db(dog)
       end
    end

end
dog_1 = Dog.new(name:"oscar",breed:"african")
puts dog_1
dog_1.save

