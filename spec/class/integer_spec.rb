require 'spec_helper'

RSpec.describe Integer do
  class IntegerObject < Ruson::Base
    field :count, class: Integer
  end

  it 'cast to integer' do
    obj = IntegerObject.new({ count: '1204' })
    expect(obj.count).to eq 1204

    obj = IntegerObject.new({ count: 'example' })
    expect(obj.count).to eq 0
  end
end
