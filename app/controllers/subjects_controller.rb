class SubjectsController < ApplicationController
  ######################################
  before_filter :load_board 
  before_filter :load_nav_options
  ######################################

  ####################
  #update_permissions should get
  #=>
  # and should return
  #=>
  def update_subject_permissions
    @subject = Subject.find(params[:subject_id])
    user_login = params[:user][:login] unless params[:user].nil?
    @us    = User.find_by_login(user_login) 
    @ac    = params[:level]
    @subject.allow!( @us, @ac.to_sym ) unless @us.nil?
    @subject.inherit_permissions! if params[:inherits]
  end

  def show
   @subject = Subject.find_from( params )
   unless current_user.can(:read, @subject )
    flash[:notice] = "You do not have read access! "
    redirect_to :back
   end
  end

  def new
    @subject = @board.subjects.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  def edit
    @subject = Subject.find_from( params )
  end

  def create
    @subject = @board.subjects.build(params[:subject])
    respond_to do |format|
      if @subject.save
        @subject.inherit_owner!
        @subject.allow!(current_user,:write) unless @subject.inherits
        flash[:notice] = 'Subject was successfully created.'
        format.html { redirect_to user_board_url( :user_name => @board.user.login, 
                                                  :board_url => @board.url) }
        format.xml  { render :xml => @subject, :status => :created, :location => @subject }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @subject = Subject.find_from( params )
    respond_to do |format|
    debugger
    if @subject.update_attributes(params[:subject])
        update_type , message = @subject.update_hooks( params )
        case update_type
          when :permissions
            format.js   {render :action => 'update_subject_permissions.rjs'}
          when :epoch_fail
            format.js { render :js => " alert( '#{ message }' )"}
        end#case
        format.html { redirect_to user_board_url( :user_name => @board.user.login, 
                                                  :board_url => @board.url) }
        format.xml  { head :ok }
      else# there was an error 
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end#if
    end#do
  end#method

  def destroy
    @subject = Subject.find_from( params )
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to user_board_url( :user_name => @board.user.login, 
                                                :board_url => @board.url) }
      format.xml  { head :ok }
    end
  end
protected
  ####################
  #load_board should get
  #=>
  # and should return
  #=>
  def load_board
    @board = Board.find_from( params )
  end
  ####################
  #load_nav_top should get
  #=>
  # and should return
  #=>
  def load_nav_options
    @nav_options = Array.new
  end
end#end class
