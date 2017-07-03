class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @tasks=Task.all.page(params[:page])
  end

  def show
    @tasks=Task.all.page(params[:page])
  end 
  
  def new
    @task=Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save 
      flash[:success]='タスクが正常にcreateされました'
      redirect_to root_url
      
    else 
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger]='タスクcreate失敗！'
      render 'toppages/index'
    end 
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    if @task.update(task_params)
      flash[:success]='タスクが正常にupdateされました'
      redirect_to @task
    
    else 
      flash.now[:danger]='タスクのupdateに失敗しました！'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success]='タスクは正常にdestroyされました'
    redirect_back(fallback_location: root_path)
  end

private 

  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
      unless @task 
        redirect_to root_url
      end
  end
end 