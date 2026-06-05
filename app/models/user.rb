class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Связь с задачами
  has_many :tasks, dependent: :destroy
  
  # Проверка на админа
  def admin?
    admin == true
  end
  
  # Проверка прав на задачу
  def can_manage_task?(task)
    admin? || task.user_id == id
  end
end