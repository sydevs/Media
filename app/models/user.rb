class User < ApplicationRecord
  has_many :actions, class_name: 'UserAction'
end
