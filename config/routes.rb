ActionController::Routing::Routes.draw do |map|
  map.resources :users

  map.resources :users
  map.connect 'admin/login', :action=>'login', :controller=>'admin'
  map.connect 'admin/logout', :action=>'logout', :controller=>'admin'
  map.connect 'master_maps/select_action', :action=>'select_action', :controller=>'master_maps'
  map.connect 'master_maps/open', :action=>'open', :controller=>'master_maps'
  map.connect 'master_maps/destroy_master_map', :action=>'destroy_master_map', :controller=>'master_maps'
  map.connect 'categories/set_blueprint', :action=>'set_blueprint', :controller=>'categories'
  map.connect 'categories/progress', :action=>'progress', :controller=>'categories'
  map.connect 'categories/new_tree', :action=>'new_tree', :controller=>'categories'
  map.connect 'categories/show_tree', :action=>'show_tree', :controller=>'categories'
  map.connect 'categories/show_graph', :action=>'show_graph', :controller=>'categories'
  map.resources :categories, :collection => {:dragdrop => :get, :showtree=>:get}
  map.resources :master_maps

  map.resources :blueprints
  map.connect 'show_tree/index', :action=>'index', :controller=>'show_tree'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'index'
end
