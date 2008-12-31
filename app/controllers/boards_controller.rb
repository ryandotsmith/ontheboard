class BoardsController < ApplicationController
  ###########################
  before_filter :load_user, :except => [:index]
  padlock(:on => :show) { grab_board( params ).is_readable_by( @user )}
  ###########################

  def index
    @boards = Board.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  def show
    unless params[:user_name].nil?
      @board  = Board.find_by_user_id(User.find_by_login(params[:user_name]).id)
    else
      @board = Board.find(params[:id])
    end

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
    @board = grab_board(params)
  end

  def create
    @board = @user.boards.build(params[:board])
    @board.make_owner!( @user )
    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to board_url(:id => @board.id) }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @board = grab_board(params)    
    #this will rename the url with the updated title
    respond_to do |format|
      if @board.update_attributes(params[:board]) 
        @board.set_url(params[:board][:title])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to user_board_url( :user_name => @board.user.login,
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
    unless @user
      flash[:notice]= "You must <a href='/login''>log in</a>to do this"
      #redirect_to boards_url
    end#end unless
    @user
  end
  ####################
  #grab_board(params) should get
  #=>
  # and should return
  #=>
  def grab_board(params)
    user  = User.find_by_login(params[:user_name])
    board_url = params[:board_url]
    unless user.nil?
      board = Board.find(:first, :conditions => "user_id = '#{user.id}' AND url = '#{board_url}'")
    else
      board = Board.find(params[:id])
    end# end unless
    board
  end
end# end class
