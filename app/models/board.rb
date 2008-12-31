class Board < ActiveRecord::Base
  acts_as_authorizable
  belongs_to :user
  
  acts_as_url :title
  
  def to_param
     url
  end
  ####################
  #find_from( params ) should get
  #=>
  # and should return
  #=>
  def find_from( params )
    user      = User.find_by_login(params[:user_name])
    board_url = params[:board_url]
    board = Board.find(:first, :conditions => "user_id = '#{user.id}' AND url = '#{board_url}'")
  end
  ####################
  #set_url should get
  #=>
  # and should return
  #=>
  def set_url( new )
    self.url = new.to_url
    self.save!
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
    self.accepts_role? :owner, user
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
      return( self.accepts_role? :subscriber, user )
    end
  end
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
  end
  
end#end class