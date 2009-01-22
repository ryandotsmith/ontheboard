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
  def get_users_with_tallies
    results = Hash.new
    tallies.each  do |tally|
      results[tally.user_id] += 1
    end
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
   self.is_public = board.is_public
   save!
  end
  ####################
  #is_readable_by( user ) should get
  #=> the current user in the session
  # and should return true if the user can read
  #=>
  def is_readable_by( user )
    if self.is_public || self.accepts_role?( :owner, user ) 
      return true
    else
      return( self.accepts_role? :reader, user ) 
    end#end if
  end#end method
  ####################
  #is_writeable( user )should get
  #=> the current user that is in session
  # and should return
  #=> true if the user is the owner of the object
  #=> and return false otherwise 
  #=> accepts_role? is a mehtod given by padlock_authorization
  def is_writeable_by( user )  
    if user.is_a?(AnonUser::Anon)
      return false
    else
       self.accepts_role? :owner, user
    end
  end#end method
  ####################
  #is_exec_by( user ) should get
  #=>
  # and should return
  #=>
  def is_exec_by( user )
    if self.is_public
      return true
    else
      return( self.accepts_role?(:subscriber, user) || self.accepts_role?( :owner, user ) )
    end# if else
  end# def
  ####################
  #make_owner!( user ) should get
  #=> The current user in the session
  # and should return
  #=> true when the role has been added.
  # accepts_role without '?' will add the role to the object.
  def make_owner!( user )
    self.accepts_role :owner, user
  end# end method
  ####################
  #make_reader!( user ) should get
  #=> the current user in the session 
  # and should return 
  #=>true if the role was added
  # this will add the user as a reader to the object
  def make_reader!( user )
    self.accepts_role :reader, user
  end
  ####################
  #make_subscriber!( user ) should get
  #=> the current user in the session   
  # and should return
  #=> true if the role is applied
  def make_subscriber!( user )
    self.accepts_role :subscriber, user
  end# def
  
end# class
