Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    put "assume_user", to: "users/sessions#assume", as: "assume_user"
    delete "release_user", to: "users/sessions#release", as: "release_user"
    get "clear_session", to: "users/sessions#clear", as: "clear_session"
  end  
  devise_for :system_users

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  authenticate :system_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: "users#show"

  get 'help', to: 'help#index' # '/help', controller:  'Help', action:  'index'
  get 'system', to: 'system#index'
  get 'admin', to: 'admin#index'
  get 'survey', to: 'survey#index'
  get 'home', to: 'users#show'

#   system '/system', controller:  'System', action:  'index'
#   survey '/survey/', controller:  'Survey', action:  'index'

#   logout   '/logout',   controller:  'sessions', action:  'destroy'
#   login    '/login',    controller:  'sessions', action:  'new'
#   home     '/home',     controller:  'users',    action:  'show'
#   home     '/admin',    controller:  'Admin::Chambers',    action:  'show'

#   remember_password '/remember_password',
#     controller:  'users',
#     action:  'remember_password'
#
#   reset_password '/reset_password/:password_reset_code',
#     controller:  'users',
#     action:  'reset_password',
#     password_reset_code:  nil
#
#   activate '/activate/:activation_code',
#     controller:  'users',
#     action:  'activate',
#     activation_code:  nil
#
#   legacy_activate '/start/initUser.cgi',
#     controller:  'users',
#     action:  'activate',
#     activation_code:  nil


#   root controller:  :sessions, action:  :new

  resources :users do
    collection do
      post :request_password_reset
      post :confirm_payment
      patch :update_password
      get :edit_password
    end
  end

  namespace :payments do
    get  :elavon
    post :elavon_checkout
  end

  # resource :session, member:  {
  #   assume:  :put, release:  :put
  # }

  resources :members do
    get :details, on: :member
  end
  resources :administrators
  resources :instructors
  resources :executives

  resources :discussions do
    resources :comments
  end
  resource :comments


  resources :legislation do #, singular:  :legislation_instance,
    get :search, on: :collection
    put :add_cosponsor, on: :member
    put :remove_cosponsor, on: :member
  end
  resources :committees do
    get :membership_requests, on: :collection
    put :update_membership_requests, on: :collection
    member do
      post :generate_special_rule
      post :propose_special_rule
      get  :draft_special_rule
      get  :manage_special_rules
      get  :manage_discussions
      get  :manage_referrals
      get  :manage_votes
      get  :manage_info
      get  :manage
    end
  end

  resources :sections do
    member do
      get :manage_discussions
      get :manage_referrals
      get :manage_info
      get :manage
    end
  end
  resources :caucuses do
    member do
      patch :join
      patch :leave
      get :manage_discussions
      get :manage_referrals
      get :manage_info
      get :manage_votes
      get :manage
    end
  end
  resources :parties do
    member do
      patch :join
      patch :leave
      get :manage_discussions
      get :manage_referrals
      get :manage_info
      get :manage_votes
      get :manage
    end
  end
  resources :floors do
    member do
      get  :manage_info
      get  :manage_referrals
      get  :manage_calendars
      get  :manage_votes
      get  :manage_proceedings
      get  :new_proceeding
      get  :previous_proceeding
      post :create_previous_proceeding
      post :propose_proceeding
      post :generate_proceeding
      get  :manage
    end
  end
  resources :legislative_types
  resources :letters do
    get :reply, on: :member
    get :reply_all, on: :member
    get :sent, on: :collection
  end

  resources :leadership_nominations

  resources :survey do
    put :create, on: :member
  end

  resources :votes do
    member do
      patch  :cancel
      get    :edit_previous
      post   :create_previous
      patch  :update_previous
    end
  end
  resources :ballots
  resources :motions do
    member do
      post :join_filibuster
      post :leave_filibuster
    end
  end

  resources :calendars do
    collection do
      post :add_items
      get  :holds
      post :place_hold
      post :remove_hold
    end
  end
  resources :surveys
  resources :tutorials
  resources :instructions

  resources :chambers do
    member do
      get :visit
      get :manage
      get :edit_committee_referrals
      patch :update_committee_referrals
      patch :undo_committee_referral
      get :edit_committee_assignments
      patch :update_committee_assignments
      get :edit_committee_primary_leaders
      patch :update_committee_primary_leaders
    end
    resources :legislation #, singular:  :legislation_instance
    resources :committees
    resources :caucuses
    resources :parties
    resources :legislative_types
    resources :letters, action:  'new'
  end

  resources :referrals do
    resources :amendments
    resources :reports
    resources :votes do
      collection do
        post :create_previous
        get  :previous
        get  :amendment_options
        get  :amendment_text
        get  :report_text
        get  :final_passage_options
        get  :final_passage_text
        get  :cloture_text
      end
    end
  end

  resources :reports do
    put :publish, on: :member
  end
  resources :amendments

  resources :courses do
    resources :chambers
  end

  resources :groups do
    get :csv, on: :member
    resources :calendars
    resources :votes
  end


  namespace :system do

    resources :system_users
    resources :users do
      collection do
        get :find
      end
      member do
        put :send_confirmation
        patch :update_password
        put :assume
      end
      resources :payments do
        put :refund, on: :member
      end
    end
    resources :courses do
      get :archives, on:  :collection
      resources :chambers do
        member do
          put :reinitialize
          get :export_content
        end
      end
    end

    # system authentication routes

#     system.logout   '/logout',   controller:  'sessions',     action:  'destroy'
#     system.login    '/login',    controller:  'sessions',     action:  'new'
#     system.register '/register', controller:  'system_users', action:  'create'
#     system.signup   '/signup',   controller:  'system_users', action:  'new'
#     system.reset_password '/reset_password/:password_reset_code',
#       controller:  'system_users',
#       action:  'reset_password',
#       password_reset_code:  nil
#     system.activate '/activate/:activation_code',
#       controller:  'system_users',
#       action:  'activate',
#       activation_code:  nil
#     system.resource :session, member:  {
#       assume:  :put
#     }

  end

  namespace :admin do

    resources :chambers do
      member do
        get :edit_constituencies
        put :update_constituencies
        put :init_constituencies
        get :edit_survey_questions
        put :update_survey_questions
        put :init_survey_questions
        get :edit_committees
        put :update_committeees
        put :init_committees
        get :edit_legislative_types
        put :update_legislative_types
        put :init_legislative_types
        get :edit_chamber_roles
        put :update_chamber_roles
        get :edit_contents
        put :update_contents
        get :new_referrals
        put :create_referrals
      end
    end

    resources :groups do
      get :edit_leadership, on: :collection
      put :update_leadership, on: :collection
    end

    resources :calendars do
      put :update_positions, on: :member
    end
    resources :votes
    resources :referrals
    resources :legislation do
      resources :referrals
    end
    resources :legislative_types
    resources :constituencies do
      post :mass_delete, on: :collection
    end
    resources :survey_questions

    resources :users do
      member do
        get :edit_password
        put :update_password
        put :send_password_reset
      end
    end
    resources :members do
      collection do
        get  :mass_new
        post :mass_create
        post :mass_delete
      end
    end
    resources :administrators
    resources :executives
    resources :instructors

    resources :committees do
      member do
        put :update_leadership
        put :add_members
        put :remove_members
        get :download_stats
      end
      post :mass_delete, on: :collection
    end
    resources :sections do
      member do
        put :update_leadership
        put :add_members
        put :remove_members
        get :download_stats
      end
      post :mass_delete, on: :collection
    end
    resources :parties do
      member do
        put :update_leadership
        put :add_members
        put :remove_members
        get :download_stats
      end
      post :mass_delete, on: :collection
    end
    resources :caucuses do
      member do
        put :update_leadership
        put :add_members
        put :remove_members
        get :download_stats
      end
      post :mass_delete, on: :collection
    end
    resources :floors do
      get :download_stats, on: :member
    end

    resources :groups do
      collection do
        get :committees
        get :parties
        get :caucuses
      end
    end
    resources :contents do
      get  :export, on: :collection
      post :init, on: :collection
    end
    resources :settings do
      post :mass_update, on: :collection
    end

    resources :instructions do
      post :reorder, on: :collection
    end
    resources :tutorials do
      post :reorder, on: :collection
    end
  end

  resources :examples
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
