class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    if current_user.admin?
      @tasks = case params[:filter]
               when 'completed'
                 Task.completed
               when 'pending'
                 Task.pending
               else
                 Task.all
               end
    else
      @tasks = case params[:filter]
               when 'completed'
                 current_user.tasks.completed
               when 'pending'
                 current_user.tasks.pending
               else
                 current_user.tasks
               end
    end
    
    @tasks = @tasks.order(created_at: :desc)
  end
  
  def show
  end
  
  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      redirect_to @task, notice: 'Задача успешно создана! ✅'
    else
      puts "Ошибки: #{@task.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Задача обновлена! 📝'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Задача удалена 🗑️'
  end
  
  def toggle_complete
    @task = Task.find(params[:id])
    
    unless current_user.admin? || @task.user_id == current_user.id
      redirect_to tasks_path, alert: 'У вас нет прав на это действие'
      return
    end
    
    @task.update(completed: !@task.completed)
    message = @task.completed ? 'Задача выполнена! 🎉' : 'Задача возвращена в работу 🔄'
    redirect_to tasks_path, notice: message
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:title, :description, :completed, :due_date, :priority)
  end
  
  def authorize_user!
    unless current_user.admin? || @task.user_id == current_user.id
      redirect_to tasks_path, alert: 'У вас нет прав на редактирование этой задачи'
    end
  end
end