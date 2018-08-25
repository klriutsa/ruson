require 'spec_helper'

RSpec.describe Ruson::Base do
  class RusonBaseTestSubClass < Ruson::Base
    field :test_name
  end

  class RusonBaseTestSubClass2 < Ruson::Base
    field :test_name, name: 'source_key_name'
  end

  it do
    obj = RusonBaseTestSubClass.new({})
    expect(obj).to respond_to :test_name
    expect(obj).to respond_to :test_name=
  end

  it do
    obj = RusonBaseTestSubClass.new({ test_name: 'test' })
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj           = RusonBaseTestSubClass.new({ test_name: 'test' })
    obj.test_name = 'testtest'
    expect(obj.test_name).to eq 'testtest'
  end

  it do
    obj = RusonBaseTestSubClass.new({ test_name: 'test' }.to_json)
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj           = RusonBaseTestSubClass.new({ test_name: 'test' }.to_json)
    obj.test_name = 'testtest'
    expect(obj.test_name).to eq 'testtest'
  end

  it do
    obj = RusonBaseTestSubClass2.new({ source_key_name: 'test' })
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj = RusonBaseTestSubClass2.new({ source_key_name: 'test' }.to_json)
    expect(obj.test_name).to eq 'test'
  end
end
