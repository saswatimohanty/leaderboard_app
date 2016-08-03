class UsersController <ApplicationController
  include LeaderboardMethod

  def index
    @users = User.all.order(total_commits: :desc)
  end

  def create
    @user = User.new(user_params)

    if @user.github_user?
      if @user.save
        TotalCommitsWorker.perform_async(@user.id)
        leaderboard.rank_member(@user.username, @user.total_commits)
        leaderboard.rank_for(@user.username)
        flash[:success] = I18n.t 'user.success.created'
      elsif leaderboard.check_member?(@user.username)
        flash[:danger] = I18n.t 'user.error.already_present'
      else
        flash[:danger] = I18n.t 'user.error.not_created'
      end
      redirect_to root_path
    else
      flash[:danger] = I18n.t 'user.error.invalid_github_username'
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

  private

    def user_params
      params.require(:user).permit(:name, :username)
    end
end