module PrintMyName
  extend ActiveSupport::Concern
  included do
    #logics
  end
  def my_name
     "Hello"
  end

end
