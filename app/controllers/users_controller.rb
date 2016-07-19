class UsersController <ApplicationController

	def index
    @users = User.all
  end

	def new
		@user = User.new
	end

	def create
    @user = User.new(user_params)
    @users = User.all

    if @user.github_user?
      if @user.save
        @user.update_github_information
        flash[:success] = 'Successfully added user. Check your rank now!'
      else
        flash[:danger] = 'Please enter your name and github username.'
      end
      redirect_to root_path
    else
      flash[:danger] = 'This GitHub user doesnot exist. Please enter a valid github user.'
      redirect_to root_path
    end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :username)
  	end
end