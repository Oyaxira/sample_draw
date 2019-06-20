class UsersController < ApplicationController

  def create

    data = params.require(:user).permit([
      :name,
      :password
    ])
    @user = User.new(data)
    if @user.save
      cookies.encrypted[:user] = @user.name
      redirect_to room_path
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def login
    data = params.require(:user).permit([
      :name,
      :password
    ])
    user = User.find_by_name(data[:name])
    if user.password == data[:password]
      cookies.encrypted[:user] = user.name
      redirect_to room_path
    end
  end

  def login_page
    @user = User.new
  end

  def logout
    cookies.encrypted[:user] = nil
    redirect_to room_path
  end

end
