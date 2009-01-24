class Subject < ActiveRecord::Base
  belongs_to  :board
  has_many    :tallies
  acts_as_url :title
  acts_as_authorizable
  
  def to_param
     url
  end

  ####################
  #get_users_with_tallies should get
  #=>
  # and should return
  #=>
  def get_tallies_with_users
    results = Hash.new
    tallies.each do |tally|
      user_login = User.find(tally.user_id).login.to_sym
      unless results[user_login]
        results[user_login] = 1
      else
        results[user_login] += 1
      end
    end#do
    results
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
  end# def
  ####################
  #inherit_permissions should get
  #=>
  # and should return
  #=>
  def inherit_permissions!
   self.inherits  = true
   self.is_public = board.is_public
   save!
  end
  
  ####################
  #authorize( user, action) should get
  #=>
  # and should return
  #=>
  def authorize( user, action )
    #if self.inherits
      return( board.authorize( user, action ) ) if self.inherits 
    #else
      return true if ( self.is_public && ( (action == :read) || (action == :execute) ) ) 
      case action
      when :read
        self.accepts_role?(:owner, user ) || 
        self.accepts_role?(:subscriber, user) || 
        self.accepts_role?(:reader, user ) 
      when :execute
        self.accepts_role?(:owner, user ) ||
        self.accepts_role?(:subscriber, user)         
      when :write
        self.accepts_role?(:owner, user )        
      end# case 

    #end# if 
  end#def

  ####################
  #allow( user, action ) should get
  #=>
  # and should return
  #=>
  def allow!( user, action )
    self.inherits = false
    case action
    when :read
        self.accepts_role :reader, user
    when :execute
        self.accepts_role :reader, user
        self.accepts_role :subscriber, user
    when :write    
        self.accepts_role :reader, user
        self.accepts_role :subscriber, user
        self.accepts_role :owner, user
    end# case
  end# def
  
end# class
