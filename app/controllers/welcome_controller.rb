class WelcomeController < ApplicationController
  def index
    # Если пользователь уже вошел, перенаправляем на задачи
    if user_signed_in?
      redirect_to tasks_path
    end
    # Иначе показываем приветственную страницу
  end
end