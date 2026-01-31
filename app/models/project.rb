class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id, message: "must be unique within your projects" }
  validates :domain, presence: true


  def total_tasks
    tasks.count
  end

  def completed_tasks
    tasks.where(status: "completed").count
  end
end
