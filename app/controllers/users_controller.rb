class UsersController <ApplicationController

	def index
    @users = User.all.order(total_commits: :desc)
  end

	def create
    @user = User.new(user_params)
    @users = User.all

    if @user.github_user?
      if @user.save
        flash[:success] = 'Successfully added user. You will be ranked as per contributions.'
      elsif $leaderboard.check_member?(@user.username)
        flash[:danger] = 'This Github user is already on leaderboard'
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
  	@user = User.find(params[:id])
  	if @user.destroy
  		flash[:success] = "#{@user.name} with github username '#{@user.username}' is removed from Leaderboard"
  		redirect_to root_path
  	end
  end

  def update_users
    @users = User.all
    @users.each do |user|
      $leaderboard.rank_member(user.username, user.total_commits)
      $leaderboard.rank_for(user.username)
      TotalCommitsWorker.perform_async(user.id)
    end
    redirect_to root_path
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :username)
  	end
end