class TalliesController < ApplicationController

  before_filter :load_subject
  
  def tally_board
    if current_user.can(:execute, @subject )
      @subject.tallies.create!(:user_id => current_user.id)
      respond_to do |format|
        format.js
      end# do
    else
      flash[:notice] = " #{current_user.name} does not have permission to tally"
    end# if 
  end
  
  def show
    @tally = Tally.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tally }
    end
  end

  def new
    @tally = @subject.tallies.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tally }
    end
  end

  def edit
    @tally = Tally.find(params[:id])
  end

  def create
#    @tally = @subject.tallies.build(params[:tally])
    factory = TallyFactory.new
    @tally = factory.build_tally( params )
    #@tally.user_id = User.find_by_login( current_user ).id || -1
    respond_to do |format|
      if @tally.save
        flash[:notice] = 'Tally was successfully created.'
        format.html { redirect_to user_board_url(   :user_name => @subject.board.user.login,
                                                    :board_url => @subject.board.url) }
        format.xml  { render :xml => @tally, :status => :created, :location => @tally }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tally.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @tally = Tally.find(params[:id])
    respond_to do |format|
      if @tally.update_attributes(params[:tally])
        flash[:notice] = 'Tally was successfully updated.'
        format.html { redirect_to(@tally) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tally.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @tally = Tally.find(params[:id])
    @tally.destroy
    respond_to do |format|
      format.html { redirect_to(tallies_url) }
      format.xml  { head :ok }
    end
  end

protected
  ####################
  #load_subject should get
  #=>
  # and should return
  #=>
  def load_subject
    @subject = Subject.find_from( params )
  end
end# end class 
