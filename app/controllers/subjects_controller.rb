class SubjectsController < ApplicationController
  ######################################
  before_filter :load_board 
  
  ######################################

  def show
    @subject = Subject.find_from( params )
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
      if @subject.update_attributes(params[:subject])
        flash[:notice] = 'Subject was successfully updated.'
        format.html { redirect_to user_board_url( :user_name => @board.user.login, 
                                                  :board_url => @board.url)}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

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
end#end class
