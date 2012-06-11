class MasterMapsController < ApplicationController
  # GET /master_maps
  # GET /master_maps.xml
  def open
    @master_maps=MasterMap.all
  end

  def index
    @master_maps = MasterMap.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @master_maps }
    end
  end

  def select_action
    session[:current_image]=nil
    @master_maps=MasterMap.all
    @master_map = MasterMap.new
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts session[:current_image]
  end

  # GET /master_maps/1
  # GET /master_maps/1.xml
  def show
    @master_map = MasterMap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @master_map }
    end
  end

  # GET /master_maps/new
  # GET /master_maps/new.xml
  def new
    @master_map = MasterMap.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @master_map }
    end
  end

  # GET /master_maps/1/edit
  def edit
    @master_map = MasterMap.find(params[:id])
  end

  # POST /master_maps
  # POST /master_maps.xml
  def create
    @master_map = MasterMap.new(params[:master_map])

    respond_to do |format|
      if @master_map.save
        format.html { redirect_to(:action=> :dragdrop, :controller=> :categories, :master_map=>@master_map.id)}
        format.xml  { render :xml => @master_map, :status => :created, :location => @master_map }

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @master_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /master_maps/1
  # PUT /master_maps/1.xml
  def update
    @master_map = MasterMap.find(params[:id])

    respond_to do |format|
      if @master_map.update_attributes(params[:master_map])
        format.html { redirect_to(@master_map, :notice => 'MasterMap was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @master_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /master_maps/1
  # DELETE /master_maps/1.xml
  def destroy
    @master_map = MasterMap.find(params[:id])
    @master_map.destroy

    respond_to do |format|
      format.html { redirect_to(master_maps_url) }
      format.xml  { head :ok }
    end
  end

  def destroy_master_map
    @master_map=MasterMap.find(session[:current_image])
    @master_map.destroy
    session[:current_image]=nil
    respond_to do |format|
      render :action=> :select_action, :controller=> :master_maps
    end
  end
end
