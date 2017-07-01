class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy] 
  before_action :correct_user, only: [:destroy, :edit]
  
  def index
    @tasks=Task.all.page(params[:page])
  end

  def show
  end 
  
  def new
    @task=Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save 
      flash[:success]='Taskが正常に登録されました'
      redirect_to root_url
      
    else 
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger]='Task登録失敗！'
      render 'toppages/index'
    end 
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success]='Taskが正常に更新されました'
      redirect_to @task
    else 
      flash.now[:danger]='Task更新失敗！'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success]='Taskは正常に削除されました'
    redirect_back(fallback_location: root_path)
  end

private 

  def set_task
    @task=Task.find(params[:id])
  end

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