class Asum
  class << self
    def sum(a, b)
      begin
        c = a  + b
      rescue Exception => e
        puts e.message
      end
    end
  end  
end
