class Blog < ApplicationRecord
  belongs_to :user

  has_many :tag_blogs, dependent: :destroy

  has_many :tags, through: :tag_blogs

  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :tags
end
