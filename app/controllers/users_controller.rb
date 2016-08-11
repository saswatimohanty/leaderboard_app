class UsersController <ApplicationController
  include LeaderboardMethod

  def index
    @users = User.all.order(rank: :asc).paginate(page: params[:page], per_page: 10)
    @users.each do |user|
      get_rank(user)
    end
  end

  def create
    @user = User.new(user_params)

    if @user.github_user?
      if @user.save
        TotalCommitsWorker.perform_async(@user.id)
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
    if @user.destroy and leaderboard.remove_member(@user.username)
      flash[:success] = "#{@user.name} with github username '#{@user.username}' is removed from Leaderboard"
      redirect_to root_path
    end
  end

  def update_users
    @users = User.all
    @users.each do |user|
      TotalCommitsWorker.perform_async(user.id)
    end
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :username)
    end

    def get_rank(user)
      leaderboard.rank_member(user.username, user.total_commits)
      user.rank = leaderboard.rank_for(user.username)
      user.save
    end
end