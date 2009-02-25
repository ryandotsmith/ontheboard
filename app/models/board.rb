require 'facets/dictionary'
class Board < ActiveRecord::Base
  ####################
  acts_as_authorizable
  belongs_to :user
  has_many :subjects
  acts_as_url :title, :scope => :user_id, :sync_url => true 
  #before_save :has_unique_title?
  ####################
  
  ####################
  #has_unique_title should get
  #=>
  # and should return
  #=>
  def has_unique_title?
    boards        = self.user.boards
    board_titles  = Array[ *boards.map{ |x| x[:title] } ]
    if board_titles.include?(self.title)
      errors.add :title, "But you already have a board with that name" 
      return false
    end
    return true
  end
  ####################
  #make_owner! should get
  #=>
  # and should return
  #=>
  def make_owner!( user )
    begin
      self.accepts_role :owner,   user
      self.accepts_role :read,    user
      self.accepts_role :execute, user
      self.accepts_role :write,   user
      return self.save!
    rescue
    end# rescue mission
  end# method 
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
  #update_hooks( params ) should get
  #=>
  # and should return
  #=>
  def update_hooks( params )
    params[:update_type] ||= :not_an_action
    case params[:update_type].to_sym
    when :general
      begin
        set_url( params[:board][:title])
        return :general
      rescue
        return :epoch_fail
      end
    when :permissions
      working_user = User.find_by_login( params[:login] )
      access_level = params[:level].to_sym
      begin
        allow!( working_user, access_level)
      rescue
        return :epoch_fail
      end#rescue mission
      return :permissions
    else# there was no match to :update_type
      return :epoch_fail
    end#case
  end#method
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
        self.accepts_role?(:write, user ) ||
        self.accepts_role?(:execute, user) ||
        self.accepts_role?(:read, user ) 
      when :execute
        self.accepts_role?(:write, user ) ||
        self.accepts_role?(:execute, user)         
      when :write
        self.accepts_role?(:write, user )        
      end# case 
    #end# if 
  end#def
  ####################
  #allow( user, action ) should get
  #=>
  # and should return
  #=>
  def allow!( user, action )
    # make sure the owner of the board is not being nixed! 
    return false if self.accepts_role?( :owner, user )
    # clear the permissions on the object before setting new permissions. 
    [:write, :execute, :read].each {|r| user.has_no_role( r, self ) }
    case action
    when :read
        self.accepts_role :read, user 
    when :execute
        self.accepts_role( :read, user )
        self.accepts_role( :execute, user)
    when :write    
      begin
        self.accepts_role :read, user
        self.accepts_role :execute, user
        self.accepts_role :write, user
      rescue
      end# rescue mission
    end# case
  end# def
  ####################
  #list_permissions should get
  #=>
  # and should return
  #=>
  def list_permissions
    hash =  Dictionary.new
    users = Array.new
    users = accepts_who_with_role( [ :read, :execute, :write ] )
    users.each do |user|
      hash[user.login.to_sym] = user.has_what_roles_on( self )
    end#do
    hash = hash.order_by {|key,value| value.length }
    hash = hash.reverse
    hash
  end#def
end#end class