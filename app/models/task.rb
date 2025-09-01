class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :company, presence: true
end
