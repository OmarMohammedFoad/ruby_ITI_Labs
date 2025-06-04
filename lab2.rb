module Logger





  def log_message(message=nil)
    File.open("log.txt", "a") do |file|
      file.puts "#{Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")} --info-- #{message}"
    end
  end

  def error_message(message=nil)
    File.open("log.txt", "a") do |file|
      file.puts "#{Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")} --error-- #{message}"
    end
  end

  def log_warning(message=nil)
    File.open("log.txt", "a") do |file|
      file.puts "#{Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")} --warning-- #{message}"
    end
  end
end

class Bank
  def initialize()
    raise "#{self.class} is abstract" if self.is_a?(Bank) 
  end

 def process_transactions(transaction,&block)
    raise "Method #{__method__} is abstract, please override this method"
 end
end


class CBABank < Bank

  @users = []
  include Logger
  def initialize()
    @users = []
    log_message("CBABank initialized")
  end

  def register_user(added_users)
    added_users.each do |user|
      if @users.any? { |u| u.name == user.name }
      else
      @users << user
      end
    end
  end


def process_transactions(transaction,&block)
  name_values = []
  transaction.each do |trans|
      name_values << "User #{trans.user.name} with value #{trans.value}"
  end
  log_message("Processing transaction for #{name_values.join(', ')}")
  transaction.each do |trans|
    begin
      unless @users.include?(trans.user)
        puts "Call endpoint for failure of #{trans.user.name} with value #{trans.value} with reason #{trans.user.name} not exist in the bank!! "
        error_message("User #{trans.user.name} transaction with value #{trans.value} failed with message not exist in the bank")
        next
      end
  
      new_balance = trans.user.balance + trans.value
      trans.user.balance = new_balance
  
      if new_balance > 0
        log_message("User #{trans.user.name} transaction with value #{trans.value} succeeded")
        puts "Call endpoint for success of #{trans.user.name} with value #{trans.value}"
      elsif new_balance < 0
        error_message("User #{trans.user.name} transaction with value #{trans.value} faild with message not enough balnace")

        puts "Call endpoint for failure of #{trans.user.name} with value #{trans.value} reason of not enough balance"
      else
        log_warning("User #{trans.user.name} has 0 balance.")
      end

      block.call("success") if block_given?
    
    rescue => e
      error_message("Transaction failed for #{trans.user.name} with value #{trans.value}: #{e.message}")
      block.call("failure") if block_given?
    end
  end
  
      
      
end
end
class Transaction
  attr_accessor :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end
end

  class User 
    attr_accessor  :name, :balance

    def initialize(name,balance)
      @name = name
      @balance = balance
    end
  end

  users = [
    User.new("Ali", 200),
    User.new("Peter", 500),
    User.new("Manda", 100)
  ]

  out_side_bank_users = [
    User.new("Menna", 400),
  ]


  transactions = [
    Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
  
  ]

  cba_bank= CBABank.new
  cba_bank.register_user(users);
  cba_bank.process_transactions(transactions);
