class Subject < ActiveRecord::Base
  belongs_to  :board
  has_many    :tallies
  acts_as_url :title
  acts_as_authorizable
  
  def to_param
     url
  end
  
  ####################
  #update_hooks( params ) should get
  #=>
  # and should return
  #=>
  def update_hooks( params )
    case params[:update_type]
      when 'general'
        
      when 'permissions'
        working_user = User.find_by_login( params[:user][:login] )
        access_level = params[:level].to_sym
        unless working_user.nil?
          begin 
            allow!( working_user, access_level )
          end
        end#unless
        inherit_permissions! if params[:inherits] == 'true'
        revert_permissions!  if params[:inherits] == 'false'
        return :p
      else
        return :f
    end#case
  end#def

  ####################
  #list_permissions should get
  #=>
  # and should return
  #=>
  def list_permissions
    hash =  Dictionary.new
    users = Array.new
    users = accepts_who_with_role( [ :reader, :subscriber, :owner ] )
    users.each do |user|
      hash[user.login.to_sym] = user.has_what_roles_on( self )
    end#do
    hash = hash.order_by {|key,value| value.length }
    hash = hash.reverse
    hash
    
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
  #revert_permissions! should get
  #=>
  # and should return
  #=>
  def revert_permissions!
    self.inherits  = false
    self.is_public = false
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
    # clear the permissions on the object before setting new permissions. 
    [:owner, :subscriber, :read].each {|r| user.has_no_role r, self}
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
