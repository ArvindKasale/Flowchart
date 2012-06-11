# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authorize, :except => :login
  #before_filter :check_for_session
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_uri]=request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => :admin, :action => :login
    end
  end

  
  private
  def check_for_session
    puts "%55555555555555555555555555555"
    puts session[:current_image]
    if(session[:current_image]==nil)
      session[:current_image]=0
      redirect_to(:action=>:new, :controller=>:categories) 
      return true
      
    end
    return false
  end
  
  
 def calculate_progress(vision_category)
  unless (vision_category==nil)
  puts "In calculate progress"
  puts vision_category
      $temp_vision=vision_category.dup
      vision_category.count.times do |i|
      if(check_child(i,vision_category))
        unless(vision_category[i].parent==nil)
        vision_category[i].parent.progress=0
        siblings=vision_category[i].self_and_siblings
            siblings.count.times do |j|
              vision_category[i].parent.progress+=(siblings[j].progress) 
            end
            vision_category[i].parent.progress/=siblings.count
            vision_category[i].parent.save
            
            $temp_vision.delete(vision_category[i])
            end
          end
    end
    unless($temp_vision.count<=1)
    calculate_progress($temp_vision)
    end
  end
end

def check_child(i,vision_category)
  count=true
  vision_category.count.times do |j|
     if (vision_category[j].parent_id==vision_category[i].id)
       count=false
     end
   end
   return count
end
 
def get_graph_data
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
end
