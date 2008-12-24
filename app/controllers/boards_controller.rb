class BoardsController < ApplicationController
  ###########################
  before_filter :load_user, :except => [:index]
  padlock(:on => :show) { Board.find(params[:id]).is_readable_by( @user )}
  ###########################

  def index
    @boards = Board.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  def show
    @board = Board.find(params[:id])
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
    @board = Board.find(params[:id])
  end

  def create
    @board = @user.boards.build(params[:board])
    @board.make_owner!( @user )
    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to(@board) }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @board = Board.find(params[:id])
    respond_to do |format|
      if @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to(@board) }
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
      redirect_to boards_url
    end#end unless
    @user
  end
end# end class
