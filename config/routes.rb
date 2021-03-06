ActionController::Routing::Routes.draw do |map|

  # These routes are defined for the use of restful-authentication
  # 
  map.logout    '/logout',      :controller => 'sessions', :action => 'destroy'
  map.login     '/login',       :controller => 'sessions', :action => 'new'
  map.register  '/register',    :controller => 'users',    :action => 'create'
  map.signup    '/signup',      :controller => 'users',   :action => 'new'
  map.activate  '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        #:has_one  => :page,
                        :has_many => :boards do |user|
                                      user.resource :boards
                                     end
 map.resource :session
 map.resources :boards,   :only =>  [ :new, :create, :destroy ] , :has_many => :subjects

 #map.resources :pages
 #map.resources :subjects, :only =>  [ :new, :create, :destroy ]
 #map.resources :tallies
 map.board_auto_complete ':user_name/:board_url/auto_complete_for_user_login', 
 :controller    => 'users',
 :requirements  => { :action => 'auto_complete_for_user_login' },
 :conditions    => { :method => :get }

 map.subject_auto_complete ':user_name/:board_url/:subject_name/auto_complete_for_user_login', 
 :controller    => 'users',
 :requirements  => { :action => 'auto_complete_for_user_login' },
 :conditions    => { :method => :get }

 map.search_user '/search',
 :controller  => 'users', 
 :action      => 'search',
 :conditions  => {:method => :get}

 map.user_page   '/:user_name',                  
 :controller => 'pages',  
 :action => 'show' 
 map.user_board  '/:user_name/:board_url',       
 :controller => 'boards', 
 :action => 'show',   
 :conditions => { :method => :get }
 map.edit_board  '/:user_name/:board_url/edit',  
 :controller => 'boards', 
 :action => 'edit',   
 :conditions => { :method => :get }
 map.update_board'/:user_name/:board_url/edit',       
 :controller  => 'boards', 
 :action      => 'update',
 :conditions   => { :method => :put }
 map.update_board_permissions '/:user_name/:board_url/update_board_permissions',
  :controller   =>  'boards',
  :action       =>  'update_board_permissions'
############################
# Subject
#
 map.new_subject '/:user_name/:board_url/new',   
  :controller   =>  'subjects', 
  :action       =>  'new', 
  :conditions   =>  {:method  => :get }
 map.create_subject '/:user_name/:board_url/new',
  :controller   =>  'subjects', 
  :action       =>  'create', 
  :conditions   =>  {:method => :post }  
 map.show_subject'/:user_name/:board_url/:subject_name', 
  :controller   =>  'subjects', 
  :action       =>  'show',
  :conditions   =>  { :method => :get }
  
 map.edit_subject'/:user_name/:board_url/:subject_name/edit',
  :controller   =>  'subjects',
  :action       =>  'edit',
  :conditions   =>  { :method => :get }
 map.update_subject '/:user_name/:board_url/:subject_name/edit',
  :controller   =>  'subjects',
  :action       =>  'update',
  :conditions   =>  { :method => :put }
 map.destroy_subject '/:user_name/:board_url/:subject_name/',
  :controller   =>  'subjects',
  :action       =>  'destroy',
  :conditions   => {:method => :delete }
 map.update_subject_permissions '/:user_name/:board_url/:subject_name/update_subject_permissions',
  :controller   =>  'subjects',
  :action       =>  'update_subject_permissions'
 map.show_sort '/:user_name/:board_url/:subject_name/sort',
  :controller   =>  'subjects',
  :action       =>  'sort'
  
############################
# Tally
#
 map.new_tally '/:user_name/:board_url/:subject_name/new',
  :controller   =>    'tallies',
  :action       =>    'new',
  :conditions   =>    {:method  =>  :get}
 map.create_tally '/:user_name/:board_url/:subject_name/new',
  :controller   =>  'tallies', 
  :action       =>  'create', 
  :conditions   =>  {:method => :get }  
 map.tally_board '/:user_name/:board_url/:subject_name/tally',
  :controller   =>  'tallies',
  :action       =>  'tally_board'
 
#  map.show_tally'/:user_name/:board_url/:subject_name/', 
#   :controller   =>  'subjects', 
#   :action       =>  'show'
#  map.edit_tally'/:user_name/:board_url/:subject_name/edit',
#   :controller   =>  'subjects',
#   :action       =>  'edit',
#   :conditions   =>  { :method => :get }
#  map.update_tally '/:user_name/:board_url/:subject_name',
#   :controller   =>  'subjects',
#   :action       =>  'update',
#   :conditions   =>  { :method => :put }
#  map.destroy_tally '/:user_name/:board_url/:subject_name/',
#   :controller   =>  'subjects',
#   :action       =>  'destroy',
#   :conditions   => {:method => :delete }
  
end# end map 
