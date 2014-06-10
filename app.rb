require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  @events = Event.all.order(name: :asc)
  erb :index
end

get '/events/:id' do
  id = params[:id]
  if id == "new"
    if !signed_in?
      flash[:notice] = "You must sign in to create an event!"
      redirect '/'
    else
      erb :'events/new'
    end
  else
  @event = Event.find(id)
  @attendees = Attendee.where(event_id: id)
  erb :'events/show'
  end
end

post '/events/:id' do
  id = params[:id]
  authenticate!
  event = Event.find(id)
  attendee = Attendee.create(user: current_user, event_id: id)
  if attendee.id == nil
    flash[:notice] = "You've already joined!"
  else
    flash[:notice] = "You've successfully joined #{event.name}"
  end
  redirect "/events/#{id}"
end


post '/events/new' do
  event = Event.create(name: params["name"], location: params["location"], description: params["description"])
  redirect "/events/#{event.id}"
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/events/new' do
  erb :'events/new'
end

get '/example_protected_page' do
  authenticate!
end
