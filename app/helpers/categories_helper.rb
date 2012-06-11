module CategoriesHelper
  def find_if_first
    @cat=Category.all(:conditions=>["master_map_id=?",session[:current_image]])
    if @cat==nil
      "Make this the root node"
    else
    false
    end
  end

  def check_if_child
    if ((@category.leaf?)&&(@category.vision==1))
    false
    else
    true
    end

  end

  def nested_set_options(class_or_item, mover = nil)
    class_or_item = class_or_item.roots if class_or_item.is_a?(Class)

    items = Array(class_or_item)
    items=items.delete_if{|x| x.master_map_id != session[:current_image].to_i}
    result = []
    items.each do |root|
      result += root.self_and_descendants.map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          [yield(i), i.id]
        end
      end.compact
    end
    result

  end

  def select_categories
    @categories=Category.all(:conditions=>["master_map_id=?",session[:current_image]])
  end
  
  def findCurrentUser(user_id)
    @user=User.find(user_id)
    return @user.name
  end
  
end
