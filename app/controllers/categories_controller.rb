class CategoriesController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::FormOptionsHelper
  layout 'application', :only=>[:new, :edit, :index, :show]
    #after_filter :cleandata_create, :only=> [:create]
  #after_filter :cleandata_edit, :only=> [:update] 
  #before_filter :original_show, :only=> [:show]
  #before_filter :original_index, :only=> [:index]
  before_filter :showtree, :only=> [:dragdrop, :update_graph]
  before_filter :show_graph, :only=>[:create, :new_tree]
  #before_filter :check_for_cancel, :only=>[:edit, :update]
  
  def update_graph
  render :update do |page|
   page.replace_html :mainPanel, (render :action=> :show_graph)
  end
  end
  
  def update_tree
  all_roots=Category.roots
  @root=all_roots.all(:conditions=>["master_map_id=?",session[:current_image]])
  render :update do |page|
    page.replace_html :tree, (render :partial=> "partials/tree")
  end
end

def set_blueprint
  puts "99999999999999999999999999999999999999999"
  puts $blueprint_id
  puts "99999999999999999999999999999999999999999"
end

def edit_blueprint
   @blueprint=Blueprint.find($blueprint_id) 
end
  
 
def progress_done
  id=params[:id]
  @category=Category.find(id)
  check_if_vision
  
end

def index
  @categories = Category.all
end

  #View that contains the partial for new tree element creation
def new_tree
  @category=Category.new
end
  
  #View that contains the partial for viewing the tree structure
  def show_tree
    all_roots=Category.roots
    @root=all_roots.all(:conditions=>["master_map_id=?",session[:current_image]])
    
  end
  
  def dragdrop
    session[:current_image] =params[:master_map]
    puts "33333333333333333333333333333333333"
    puts session[:current_image]
    $blueprint_id= nil
    #$master_map=params[:master_map]
    @category=Category.new
    vision_category=Category.find(:all, :conditions =>["vision=? and master_map_id=? ",1,session[:current_image]])
    calculate_progress(vision_category)
   
  end  
  
  def show
    @category=Category.find(params[:id])
  end
  
  def new
    @category = Category.new
  end
  
  def create
   
    all_roots=Category.roots
    @root=all_roots.all(:conditions=>["master_map_id=?",session[:current_image]])
    puts "***********5555555555555555**************************"
    p @root
    @category = Category.new(params[:category])
    if @category.save
      puts "Inside Save"       
      get_graph_data
       respond_to do |format| 
        format.js
        format.html{redirect_to (:action => :index)}
       end
    else
      flash[:notice] ="Unable to create the category."
      redirect_to :action => :dragdrop
    end
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    all_roots=Category.roots
    @root=all_roots.all(:conditions=>["master_map_id=?",session[:current_image]])
    if @category.update_attributes(params[:category])
      
       #calling the function that calculates the strategy progress
       vision_category=Category.find(:all, :conditions =>["vision=? and master_map_id=?",1,session[:current_image]])
       calculate_progress(vision_category)
       #end of function
       puts "***********Updating***************"
       get_graph_data
       respond_to do |format|
        format.js
        format.html{redirect_to (:action=> :index)}
    end
    else
        redirect_to :action=> :dragdrop
    end
  end
  
  def showtree
    @categories=Category.find(:all)
    puts @categories
    @categories.each do |category|
       #category.name=escape_javascript(category.name)
       puts category.name
       category.name=category.name.gsub!(/"/,'\"')
       category.description=category.description.gsub!(/"/,'\"')
       
       #category.name=category.name.gsub("\\","\\\\\\\\").gsub("'","\\\\'")
       
       #category.name=category.name.gsub(/'/,"\'")
       #category.description=category.description.gsub(/'/,"\'")
    end
    @jsondata=@categories.to_json(:only=>[:id, :name, :description, :parent_id])
  end
  
  def destroy
    all_roots=Category.roots
    @root=all_roots.all(:conditions=>["master_map_id=?",session[:current_image]])
    @category = Category.find(params[:id])
    @category.destroy
    get_graph_data
    respond_to do |format|
    format.js 
    format.html {redirect_to categories_url}
    end
  end
#  --- THE CODE BELOW DEALS WITH SAVING THE SORTED LIST ---
#  --- I WELCOME ANY SUGGESTIONS TO REFACTOR THIS (do the same with less database calls) ---
  def array
     # assign the sorted tree to a variable
     newlist = params[:ul]
     # initialize the previous item
     previous = nil
     #loop through each item in the new list (passed via ajax)
     newlist.each_with_index do |array, index|
       # get the category id of the item being moved
       moved_item_id = array[1][:id].gsub(/category_/,'')
       # find the object that is being moved (in database)
       @current_category = Category.find_by_id(moved_item_id)
       # if this is the first item being moved, move it to the root.
       unless previous.nil?
         @previous_item = Category.find_by_id(previous)
         @current_category.move_to_right_of(@previous_item)
       else
         @current_category.move_to_root
       end
       # then, if this item has children we need to loop through them
       unless array[1][:children].blank?
         # NOTE: unless there are no children in the array, send it to the recursive children function
         childstuff(array[1], @current_category)
       end
       # set previous to the last moved item, for the next round
       previous = moved_item_id
     end
     Category.rebuild!
     render :nothing => true
   end
   
def childstuff(mynode, category)
     #loop through it's children - this is a hash that needs to be sorted
     for child in mynode[:children].sort
       # get the child id from each child passed into the node (the array)
       child_id = child[1][:id].gsub(/category_/,'')
       #find the matching category in the database
       child_category = Category.find_by_id(child_id)
       #move the child to the selected category
       child_category.move_to_child_of(category)
       # loop through the children if any
       unless child[1][:children].blank?
         # if there are children - run them through the same process
         childstuff(child[1], child_category)
       end
     end
   end
   




def show_graph
  get_graph_data
end

def change_selected_blueprint
    @blueprint=Blueprint.new
    @category=Category.new
    blueprint_id=params[:blueprint_id] 
    $blueprint_id=blueprint_id
    session[:blueprint_id]=blueprint_id
    puts "##########*********##############"
    p @blueprint_id
    puts "#####***************############"
    if(blueprint_id=="")
      puts "This is Blank"
      render :update do |page|
        page[:panel2_title].replace_html("New Blueprint")
        page[:panel2].replace_html(render :partial=> 'partials/blueprint/new', :object=> @blueprint)
      end
    else
      render :update do |page|
        page[:panel2_title].replace_html("New Element")
        page[:panel2].replace_html(render :partial=> 'partials/new', :object=> @category)
      end
    end
end

def check_for_cancel
    puts"Came to pre update"
    @category=Category.new
    @blueprint=Blueprint.new
    respond_to do |format|
    format.js
    end
end

def create_edit_box
  @category=Category.find(params[:id])
  respond_to do |format|
    format.js
  end
end


  
private
  def get_graph_data
    puts "4444444444444444444444444444444"
    puts $master_map
    puts "44444444444444444444444444444444"
    @categories=Category.find(:all, :conditions=>["master_map_id=?",session[:current_image]])
    
    @categories.each do |category|
       #category.name=escape_javascript(category.name)
       #category.name=category.name.gsub(/"/,'\"')
       #category.description=category.description.gsub(/"/,'\"')
       category.name=escape_javascript(category.name)
       category.description=escape_javascript(category.description)
       #category.name=category.name.gsub("\\","\\\\\\\\").gsub("'","\\\\'")
       
       #category.name=category.name.gsub(/'/,"\'")
       #category.description=category.description.gsub(/'/,"\'")
    end
    puts "************************"
    
    puts "************************"
    @jsondata = @categories.to_json({:include=>{:blueprint=>{:only=>[:node_type, :color, :vision]}}})
    #puts @jsondata
end


  
  
  def check_if_vision
    if(@category.vision==1)
      respond_to do |format|
      format.js
      end
   end
  end


end