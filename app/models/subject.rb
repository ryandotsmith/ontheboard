class Subject < ActiveRecord::Base
  belongs_to  :board
  has_many    :tallies
  acts_as_url :title
  acts_as_authorizable
  
  def to_param
     url
  end
  ####################
  #update_hooks( params ) 
  # there is a hidden field on any form that will send a 
  # put request. This hidden filed sets a value for params(:update_type)
  # this params value is sent to the update_hook method which will act upon
  # the described update. The update_hooks method will kick back a symbol 
  # describing what sort of updat took place. Then, the appropriate response will
  # be generated. 
  def update_hooks( params )
    params[:update_type] ||= :not_an_action
    message = String.new
    case params[:update_type].to_sym
      when :general
        return :general , message
      when :permissions
        #user_login = params[:login] unless params[:login]
        working_user = User.find_by_login( params[:login] )
        access_level = params[:level].to_sym
        unless working_user.nil?
          unless allow!( working_user, access_level )
            message = "unable to update permissions!"
            return :epoch_fail, message
          end#unless
        end#unless
        inherit_permissions! if params[:inherits] == 'true'
        revert_permissions!  if params[:inherits] == 'false'
        return :permissions, message
      else
        message = "unknown action"
        return :epoch_fail, message
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
    users = accepts_who_with_role( [ :read, :each, :write ] )
    users.each do |user|
      hash[user.login.to_sym] = user.has_what_roles_on( self )
    end#do
    hash = hash.order_by {|key,value| value.length }
    hash = hash.reverse
    hash
    
  end
  ####################
  #get_users_with_tallies should get
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
  #inherit_owner 
  # the order of allow! and accepts_role is very important.
  # allow! will fail if the user is an owner, therefore the 
  # user must be given write permissions before the user is made owner. 
  # This method gets called right after the subject is saved in the controller.
  #
  def inherit_owner!
    owner_of_board = self.board.accepts_who_with_role( :owner ).first
    self.allow!( owner_of_board, :write)
    self.accepts_role :owner, owner_of_board
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
  # authorize( user, action) 
  def authorize( user, action )
      return( board.authorize( user, action ) ) if self.inherits 
      return true if   self.accepts_role?( :write, user)
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
  #allow( user, action ) 
  # This method is what modifies the permission settings 
  # on a subject. This method will get called from the update hooks. 
  # This method ensures that the permissions will not get changed for the 
  # owner of the subject. Once you are made an owner.... you are made! 
  #
  #=>
  def allow!( user, action )
    self.inherits = false
    # make sure that we are not going to axe the owner of the board. 
    return false if self.accepts_role? :owner, user
    # clear the permissions on the object before setting new permissions. 
    [:write, :execute, :read].each {|r| user.has_no_role r, self}
    case action
    when :read
        self.accepts_role :read, user
    when :execute
        self.accepts_role :read, user
        self.accepts_role :execute, user
    when :write    
        self.accepts_role :read, user
        self.accepts_role :execute, user
        self.accepts_role :write, user
    end# case
  end# def
  
end# class
