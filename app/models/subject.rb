class Subject < ActiveRecord::Base
  belongs_to  :board
  has_many    :tallies
  acts_as_url :title
  
  def to_param
     url
  end


  ####################
  #self.find_from( params ) should get
  #=>
  # and should return
  #=>
  def self.find_from( params )
    board = Board.find_from( params )
    name  = params[:subject_name]
    subject = Subject.find(:first, :conditions  => "board_id = '#{board.id}' and url = '#{name}'")    
  end
end
