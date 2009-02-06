require 'facets/dictionary'
class Board < ActiveRecord::Base
  ####################
  acts_as_authorizable
  belongs_to :user
  has_many :subjects
  acts_as_url :title
  ####################
  
  ####################
  # to_param is used by acts_as_url
  def to_param
     url
  end
  ####################
  #find_from( params ) should get
  #=>
  # and should return
  #=>
  def self.find_from( params )
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
  #authorize( user, action) should get
  #=>
  # and should return
  #=>
  def authorize( user, action )
    #if self.inherits
    #  return( board.authorize( user, action ) )
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
    case action
    when :read
        self.accepts_role :reader, user 
    when :execute
        self.accepts_role( :reader, user )
        self.accepts_role( :subscriber, user)
    when :write    
        self.accepts_role :reader, user
        self.accepts_role :subscriber, user
        self.accepts_role :owner, user
    end# case
  end# def
  ####################
  #list_permissions should get
  #=>
  # and should return
  #=>
  def list_permissions
    hash =  Dictionary.new
    array = Array.new
    array = accepts_who_with_role( [ :reader, :subscriber, :owner ] )
    array.each do |user|
      hash[user.login.to_sym] = user.has_what_roles_on( self )
    end#do
    hash 
  end#def
end#end class