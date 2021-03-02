class FriendsController < ApplicationController
  before_action :set_friend, only: %i[show edit update destroy]
  before_action :delete_friend, only: %i[destroy]

  # GET /friends
  # GET /friends.json
  def index
    @friends = Friend.all
  end

  # GET /friends/1
  # GET /friends/1.json
  def show; end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit; end

  # POST /friends
  # POST /friends.json
  def create
    @friend = Friend.new(friend_params)
    flash[:notice] = if @friend.save
                       "You Sent Friend request to #{@friend.user.name}"
                     else
                       "You already Added #{@friend.user.name} to your list"
                     end
    redirect_to users_path
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    @friend_one = Friend.where(user_id: current_user.id, friend_id: @friend.friend_id)
    @friend_one.update(status: true)
    Friend.create!(user_id: @friend.friend_id, friend_id: current_user.id, status: true)
    redirect_to user_path(current_user)
    flash[:notice] =
      "You and #{@friend.friend.name} are now Friends ! "
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.destroy
    @delete_friend.each(&:destroy)
    redirect_to user_path(current_user)
    flash[:notice] =
      'You Removed This Friend'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friend
    @friend = Friend.find(params[:id])
  end

  def delete_friend
    @delete_friend = Friend.where(user_id: @friend.friend_id, friend_id: current_user.id)
  end

  # Only allow a list of trusted parameters through.
  def friend_params
    params.require(:friend).permit(:user_id, :friend_id, :status)
  end
end
