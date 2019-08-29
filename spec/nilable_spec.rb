require 'spec_helper'

RSpec.describe Ruson::Nilable do
  class Item < Ruson::Base
    field :id, nilable: true
    field :name, nilable: false
    field :description
  end

  it 'is not raised NotNilException' do
    expect {
      Item.new({ id: 2 })
    }.not_to raise_error(Ruson::NotNilException)
  end

  it 'is raised NotNilException' do
    expect {
      Item.new({ name: 'name' })
    }.to raise_error(Ruson::NotNilException)
  end
end