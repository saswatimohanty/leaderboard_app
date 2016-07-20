class UsersController <ApplicationController

	def index
    @users = User.all.sort_by{|u| $leaderboard.rank_for(u.username)}
  end

	def create
    user = User.new(user_params)
    @users = User.all

    if user.github_user?
      if user.save
        user.update_github_information
        flash[:success] = 'Successfully added user. Check rank now!'
      else
        flash[:danger] = 'Please enter your name and github username.'
      end
      redirect_to root_path
    else
      flash[:danger] = 'This GitHub user doesnot exist. Please enter a valid github user.'
      redirect_to root_path
    end
  end

  def destroy
  	user = User.find(params[:id])
  	if user.destroy
  		flash[:success] = "#{user.name} with github username '#{user.username}' is removed from Leaderboard"
  		redirect_to root_path
  	end
  end

  def update_users
  	User.update_github_information_for_all
  	flash[:success] = 'Leaderboard is updated successfully'
    redirect_to root_path
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :username)
  	end
end