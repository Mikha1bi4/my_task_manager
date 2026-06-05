class Task < ApplicationRecord
  belongs_to :user
  
  # Устанавливаем значение по умолчанию для completed
  attribute :completed, :boolean, default: false
  
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :priority, presence: true, inclusion: { in: %w[low medium high] }
  
  # Enum для приоритетов (храним как строки в базе)
  enum priority: {
    low: 'low',
    medium: 'medium',
    high: 'high'
  }
  
  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  
  # Callback для гарантии, что completed не nil
  before_save :ensure_completed_not_nil
  
  # Методы
  def status
    completed? ? "✅ Выполнено" : "⏳ В процессе"
  end
  
  def priority_name
    case priority
    when 'high' then '🔴 Высокий'
    when 'medium' then '🟡 Средний'
    else '🟢 Низкий'
    end
  end
  
  def overdue?
    due_date.present? && due_date < Date.today && !completed?
  end
  
  private
  
  def ensure_completed_not_nil
    self.completed = false if completed.nil?
  end
end