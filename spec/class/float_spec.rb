require 'spec_helper'

RSpec.describe Ruson::Float do
  class FloatObject < Ruson::Base
    field :rate, class: Ruson::Float
  end

  it 'cast to float' do
    obj = FloatObject.new({ rate: '12.04' })
    expect(obj.rate).to eq 12.04

    obj = FloatObject.new({ rate: 'example' })
    expect(obj.rate).to eq 0
  end
end
