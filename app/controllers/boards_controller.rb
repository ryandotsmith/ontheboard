class BoardsController < ApplicationController

  ###########################
  before_filter :load_user, :except => [:index,:update_board_permissions]
  before_filter :redirect_if_anon, :only => [:new,:create,:edit]
  before_filter :can_look, :only => [:show]
  padlock(:on => [:edit,:update,:destroy]) { @user.can :write, Board.find_from( params ) }  
  ###########################


  ####################
  #update_permissions should get
  #=>
  # and should return
  #=>
  def update_board_permissions
    @board = Board.find(params[:board_id])
    @us    = User.find_by_login(params[:user][:login]) 
    @ac    = params[:level]
    #debugger
    @board.allow!( @us, @ac.to_sym )
  end

  def index
    @boards = Board.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  def show
    @board  = Board.find_from( params )
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  def new
    @board = @user.boards.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @board }
    end
  end

  def edit
    @board = Board.find_from( params )
  end

  def create
    @board = @user.boards.build(params[:board])
    @board.allow!(@user, :write )
    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to user_board_url( :user_name => @user.login, 
                                                  :board_url => @board.url) }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @board = Board.find_from( params )    
    #this will rename the url with the updated title
    respond_to do |format|
      if @board.update_attributes(params[:board]) 
        @board.set_url(params[:board][:title])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to user_board_url( :user_name => @user.login,
                                                  :board_url => @board.url)}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    respond_to do |format|
      format.html { redirect_to(boards_url) }
      format.xml  { head :ok }
    end# end do 
  end#end method 
protected
  ####################
  #load_user should get
  #=>
  # and should return
  #=>
  def load_user
    @user = current_user
    if @user.nil? and Board.find_from( params ).is_public != true 
      flash[:notice]= "You must <a href='/login''>log in</a>to do this"
      redirect_to login_url
    end#end unless
    @user
  end

  ####################
  #redirect_if_anon should get
  #=>
  # and should return
  #=>
  def redirect_if_anon
    if @user.is_a?(AnonUser::Anon)
       flash[:notice] = "You might as well just sign up for an account."
       redirect_to login_url 
    end# end if
  end
  ####################
  #can_look should get
  #=>
  # and should return
  #=>
  def can_look( user, board )
    if board.is_public || board.is_readable_by( user )
      return true
    else
      flash[:warning] = "You are not suppose to look at this board! "
      redirect_to login_url
    end# end if
  end#end method

  ####################
  #can_look should get
  #=>
  # and should return
  #=>
  def can_look
    if @user.can( :read , @board ||= Board.find_from( params ) )
      return true
    else
      redirect_to login_url    
    end# if
  end#def
  
end# end class
