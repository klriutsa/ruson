require 'spec_helper'

RSpec.describe Ruson::Base do
  let(:post_json) { File.read('spec/support/post.json') }

  it do
    obj = User.new({})
    expect(obj).to respond_to :name
    expect(obj).to respond_to :name=
  end

  it do
    obj = Post.new(post_json)
    expect(obj.title).to eq 'Ruson'
  end

  it do
    obj = User.new({ root: { name: 'name' } }, root_key: :root)
    expect(obj.name).to eq 'name'
  end

  it do
    obj = User.new({ name: 'name' })
    obj.name = 'ruby'
    expect(obj.name).to eq 'ruby'
  end

  it do
    obj = User.new({ name: 'name' }.to_json)
    expect(obj.name).to eq 'name'
  end

  it do
    obj = User.new({ root: { name: 'name' } }.to_json, root_key: :root)
    expect(obj.name).to eq 'name'
  end

  it do
    obj = User.new({ name: 'name' }.to_json)
    obj.name = 'ruby'
    expect(obj.name).to eq 'ruby'
  end

  it do
    obj = Post.new(post_json)
    expect(obj.picture.class).to eq Picture
    expect(obj.picture.title).to eq 'Ruson Picture'

    expect(obj.tags.first.class).to eq Tag
    expect(obj.tags.size).to eq 2
    expect(obj.tags[0].name).to eq 'Ruby'
    expect(obj.tags[1].name).to eq 'Json'
  end

  it do
    obj = Post.new({ status: :draft })
    expect(obj.status).to eq :draft
  end

  it do
    expect do
      Post.new({ status: :undefined })
    end.to raise_error { ArgumentError }
  end

  it do
    obj = Post.new({ status: :draft })
    expect(obj.draft?).to be_truthy
    expect(obj.published?).to be_falsey
  end

  it do
    obj = Post.new({ status: :draft }.to_json)
    expect(obj.status).to eq :draft
  end

  it do
    expect do
      Post.new({ status: :undefined }.to_json)
    end.to raise_error { ArgumentError }
  end

  it do
    obj = Post.new({ status: :draft }.to_json)
    expect(obj.draft?).to be_truthy
    expect(obj.published?).to be_falsey
  end
end
