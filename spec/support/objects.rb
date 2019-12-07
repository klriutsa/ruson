class User < Ruson::Base
  field :id
  field :name
  field :url
end

class Picture < Ruson::Base
  field :id
  field :title
  field :url
end

class Tag < Ruson::Base
  field :id
  field :name
end

class Post < Ruson::Base
  field :id
  field :title
  field :user, class: User
  field :content
  field :picture, class: Picture
  field :tags, each_class: Tag
  enum :status, %i[draft published]
end

class Vehicle < Ruson::Base
  field :name
  field :price, class: Float
  field :expired_at, name: 'expiredAt', class: Time
end
