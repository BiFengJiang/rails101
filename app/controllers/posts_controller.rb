class PostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :destroy]
  before_action :find_post_and_check_permission, :only => [:new, :create]
  before_action :find_edit_post_and_check_permission, :only => [:edit, :destroy]
  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end
  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
  end

  def update
	@post = Post.find(params[:id])
	if @post.update(post_params)
	  redirect_to account_posts_path, notice: "Upadte Success"
	else
	  render :edit
	end
  end

  def destroy
    @group = Group.find(params[:group_id])
	@post = Post.find(params[:id])
	@post.destroy
	flash[:alert] = "Post deleted"
	redirect_to account_posts_path
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end

  def find_post_and_check_permission
    @group = Group.find(params[:group_id])
    if !current_user.is_member_of?(@group)
	  redirect_to group_path(@group), alert: "你不是本群組成員，無法新增。"
	end
  end

  def find_edit_post_and_check_permission
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
	if current_user != @post.user
	  redirect_to group_path(@group), alert: "你不是本文章作者，無法修改。"
	end
  end
end
