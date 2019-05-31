class RusonBaseTestSubClass < Ruson::Base
  field :test_name
end

class RusonBaseTestSubClass2 < Ruson::Base
  field :test_name, name: 'source_key_name'
end

class RusonBaseTestSubClass3 < Ruson::Base
  field :object, class: RusonBaseTestSubClass
  field :objects, each_class: RusonBaseTestSubClass2
end

class RusonBaseTestSubClass4 < Ruson::Base
  enum :status, %i[draft published]
end
