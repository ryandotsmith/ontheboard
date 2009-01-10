class TalliesController < ApplicationController
  # GET /tallies
  # GET /tallies.xml
  def index
    @tallies = Tally.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tallies }
    end
  end

  # GET /tallies/1
  # GET /tallies/1.xml
  def show
    @tally = Tally.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tally }
    end
  end

  # GET /tallies/new
  # GET /tallies/new.xml
  def new
    @tally = Tally.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tally }
    end
  end

  # GET /tallies/1/edit
  def edit
    @tally = Tally.find(params[:id])
  end

  # POST /tallies
  # POST /tallies.xml
  def create
    @tally = Tally.new(params[:tally])

    respond_to do |format|
      if @tally.save
        flash[:notice] = 'Tally was successfully created.'
        format.html { redirect_to(@tally) }
        format.xml  { render :xml => @tally, :status => :created, :location => @tally }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tally.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tallies/1
  # PUT /tallies/1.xml
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

  # DELETE /tallies/1
  # DELETE /tallies/1.xml
  def destroy
    @tally = Tally.find(params[:id])
    @tally.destroy

    respond_to do |format|
      format.html { redirect_to(tallies_url) }
      format.xml  { head :ok }
    end
  end
end
