ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'communes', :action => 'index'

  map.logout "/#{I18n.t(:logout, :scope => :routes)}",
    :controller => 'user_sessions', :action => 'destroy'

  map.resources :searches, :as => I18n.t(:searches, :scope => :routes),
    :only => [:new, :show, :create]

  map.resource :user_session, :only => [:create, :destroy], :as =>
    I18n.t(:session, :scope => :routes)

  map.resources :users, :as => I18n.t(:users, :scope => :routes),
    :path_names => {:new => I18n.t(:new, :scope => :routes),
      :edit => I18n.t(:edit, :scope => :routes),
      :inactive => I18n.t(:inactive, :scope => :routes),
      :activate_all => I18n.t(:activate_all, :scope => :routes),
      :toggle_active => I18n.t(:toggle_active, :scope => :routes)},
    :member => { :toggle_active => :put },
    :collection => { :inactive => :get, :activate_all => :put } do |users|

      users.resources :pictures, :as => I18n.t(:pictures, :scope => :routes), :only => :index
      users.resources :votes, :as => I18n.t(:votes, :scope => :routes), :only => :create
      users.resources :private_messages, :as => I18n.t(:private_messages, :scope => :routes)
      users.resources :messages, :as => I18n.t(:messages, :scope => :routes), :only => :index
    end

  map.resources :categories, :as => I18n.t(:categories, :scope => :routes),
    :except => [:index, :show], :member => {:order => :put},
    :path_names => {:new => I18n.t(:new, :scope => :routes),
      :edit => I18n.t(:edit, :scope => :routes),
      :order => I18n.t(:order, :scope => :routes)}

  map.resources :communes, :as => I18n.t(:communes, :scope => :routes),
    :member => {:order => :put},
    :path_names => {:new => I18n.t(:new, :scope => :routes),
      :edit => I18n.t(:edit, :scope => :routes),
      :order => I18n.t(:order, :scope => :routes)} do |communes|

    communes.resources :topics, :as => I18n.t(:topics, :scope => :routes),
      :except => [:index], :path_names => {:new => I18n.t(:new, :scope => :routes),
        :edit => I18n.t(:edit, :scope => :routes),
        :toggle_locked => I18n.t(:toggle_locked, :scope => :routes),
        :toggle_sticky => I18n.t(:toggle_sticky, :scope => :routes)}
      #do |topics|
      #topics.resources :replies, :as => I18n.t(:replies, :scope => :routes),
      #  :except => [:index]
    #end
  end

  map.resources :topics, :as => I18n.t(:topics, :scope => :routes),
    :only => [:show, :create, :edit, :destroy],
    :path_names => {:new => I18n.t(:new, :scope => :routes),
      :edit => I18n.t(:edit, :scope => :routes),
      :toggle_locked => I18n.t(:toggle_locked, :scope => :routes),
      :toggle_sticky => I18n.t(:toggle_sticky, :scope => :routes),
      :split => I18n.t(:split, :scope => :routes)},
    :member => { :toggle_locked => :put,
      :toggle_sticky => :put,
      :split => :put } do |topics|
    topics.resources :replies, :as => I18n.t(:replies, :scope =>  :routes),
      :except => [:index],
      :path_names => {:new => I18n.t(:new, :scope => :routes),
        :edit => I18n.t(:edit, :scope => :routes)}
    end

  map.resources :replies, :as => I18n.t(:replies, :scope => :routes),
    :only => [:show, :edit, :destroy],
    :path_names => {:edit => I18n.t(:edit, :scope => :routes)}

  map.resources :messages, :as => I18n.t(:messages, :scope => :routes),
    :member => { :quote => :get },
    :collection => {:recent => :get},
    :only => [:recent, :quote],
    :path_names => {:new => I18n.t(:new, :scope => :routes),
      :edit => I18n.t(:edit, :scope => :routes),
      :split => I18n.t(:split, :scope => :routes)}

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
