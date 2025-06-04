class Book
    
    attr_accessor :title,:author,:isbn
    @@isbn_counter = 1000
    def initialize(title,author,isbn)
      @title = title
      @author= author
      @isbn = isbn
    end  



      def to_s
        "#{@isbn},#{@title},#{@author}"
      end
end


class Inventory

    
    def initialize()
        @books = []
    end


    def load_books
      @books = []
      if File.exist?("book.txt")
        File.foreach("book.txt") do |line|
          @books << line.strip
        end
      end
    end
    
    def add_book(book)
      load_books
      @books << book
    end
    
    def insert_list_to_file(book)
      load_books
      updated = false
    
      if book.respond_to?(:isbn) && book.isbn
        isbn = book.isbn
        @books.map!.with_index do |line, idx|
          if line.include?(isbn)
            # Check if it already has a count
            if line.match(/- #{isbn} - (\d+)/)
              current_count = line.match(/- #{isbn} - (\d+)/)[1].to_i
              new_line = line.sub(/- #{isbn} - \d+/, "- #{isbn} - #{current_count + 1}")
            else
              new_line = "#{line} - #{isbn} - 2"
            end
            updated = true
            new_line
          else
            line
          end
        end
      end
    
      unless updated
        @books << book.to_s
      end
    
      File.open("book.txt", "w") do |file|
        @books.each do |b|
          file.puts(b)
        end
      end
    end
    
    
    def list_books()
      return @books
    end


    def read_from_file()
      File.open("book.txt") do |file|
        file.each do |book|
          puts book
        end
      end
    end 


    # def update()
    #   book_from_file = File.readlines("book.txt");
      
    # end
    

    def remove_from_file(isbn)
     book_from_file =  File.readlines("book.txt");
    res =   book_from_file.reject! do |book|
        book.include?(isbn)
      end
      File.open("book.txt",'w') do |file|
        file.puts(res)
      end
    end



    def search_for_book_title(title = "")
      result = nil
      book_from_file = File.readlines("book.txt");
      res = book_from_file.find do |book|
        book.include?(title)
      end
      puts res || "not found"
    end



    def search_for_book_isbn(isbn="")
      book_from_file = File.readlines("book.txt");
      res = book_from_file.find do |book|
        book.include?(isbn)
      end
      puts res || "not found"
    end
    




    def search_for_book_isbn(author="")
      book_from_file = File.readlines("book.txt");
      res = book_from_file.find do |book|
        book.include?(author)
      end
      puts res || "not found"
    end
    
        
      

end





inventory = Inventory.new

def menu
  puts "\n📚 Book Inventory CLI"
  puts "1. Add Book"
  puts "2. Search Book by Title"
  puts "3. Search Book by ISBN"
  puts "4. Search Book by author"
  puts "5. Remove Book by ISBN"
  puts "6. Show All Books"
  puts "7. Exit"
  print "Choose an option (1-7): "
end

loop do
  menu
  choice = gets.chomp

  case choice
  when "1"
    print "Enter book title: "
    title = gets.chomp
    print "Enter author: "
    author = gets.chomp
    print "Enter ISBN: "
    isbn = gets.chomp

    book = Book.new(title, author, isbn)
    inventory.insert_list_to_file(book)
    puts "✅ Book added successfully."

  when "2"
    print "Enter title to search: "
    title = gets.chomp
    inventory.search_for_book_title(title)

  when "3"
    print "Enter ISBN to search: "
    isbn = gets.chomp
    inventory.search_for_book_isbn(isbn)
  when "4"
    print "Enter author to search: "
    author = gets.chomp
    inventory.search_for_book_isbn(author)

  when "5"
    print "Enter ISBN to remove: "
    isbn = gets.chomp
    inventory.remove_from_file(isbn)

  when "6"
    inventory.read_from_file

  when "7"
    puts "👋 Exiting. Goodbye!"
    break

  else
    puts "❌ Invalid option. Try again."
  end
end


