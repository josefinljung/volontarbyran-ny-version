class Task < ApplicationRecord
  belongs_to :user

  has_many :task_categories
  has_many :categories, through: :task_categories

  validates :title, presence: true
  validates :company, presence: true

  accepts_nested_attributes_for :categories
end
