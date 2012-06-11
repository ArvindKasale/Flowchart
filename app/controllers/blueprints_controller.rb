class BlueprintsController < ApplicationController
  # GET /blueprints
  # GET /blueprints.xml
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::FormOptionsHelper
  def index
    @blueprints = Blueprint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blueprints }
    end
  end

  def destroy_blueprint
    @blueprint=Blueprint.new
    @blueprint_delete=Blueprint.find($blueprint_id)
    @categories=Category.all
    @blueprint_delete.destroy
    all_roots=Category.roots
    @root=all_roots.all(:conditions=>["master_map_id=?",session[:current_image]])
    vision_category=Category.find(:all, :conditions =>["vision=1"])
    calculate_progress(vision_category)
    get_graph_data
    respond_to do |format|
      format.js
    end
  end

  # GET /blueprints/1
  # GET /blueprints/1.xml
  def show
    @blueprint = Blueprint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blueprint }
    end
  end

  # GET /blueprints/new
  # GET /blueprints/new.xml
  def new
    @blueprint = Blueprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blueprint }
    end
  end

  # GET /blueprints/1/edit
  def edit
    @blueprint = Blueprint.find(params[:id])
  end

  # POST /blueprints
  # POST /blueprints.xml
  def create
    @blueprint = Blueprint.new(params[:blueprint])

    respond_to do |format|
      if @blueprint.save
        format.html { redirect_to(:controller=> :categories, :action=>:dragdrop) }
        format.xml  { render :xml => @blueprint, :status => :created, :location => @blueprint }
      format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blueprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blueprints/1
  # PUT /blueprints/1.xml
  def update
    @blueprint = Blueprint.find(params[:id])

    respond_to do |format|
      if @blueprint.update_attributes(params[:blueprint])
        vision_category=Category.find(:all, :conditions =>["vision=1"])
        calculate_progress(vision_category)
        get_graph_data
        format.html { redirect_to(@blueprint, :notice => 'Blueprint was successfully updated.') }
        format.xml  { head :ok }
      format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blueprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blueprints/1
  # DELETE /blueprints/1.xml
  def destroy
    @blueprint = Blueprint.find(params[:id])
    @blueprint.destroy

    respond_to do |format|
      format.html { redirect_to(blueprints_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end

