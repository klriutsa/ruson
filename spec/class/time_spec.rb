require 'spec_helper'

RSpec.describe Time do
  class TimeObject < Ruson::Base
    field :created_at, class: Time
  end

  before do
    @now = Time.local(2019, 11, 30, 10, 17, 0)
    Timecop.freeze(@now)
  end

  after do
    Timecop.return
  end

  it 'cast Time to Time' do
    obj = TimeObject.new(created_at: @now)
    expect(obj.created_at).to eq @now
  end

  it 'cast Interger to Time' do
    obj = TimeObject.new(created_at: @now.to_i)
    expect(obj.created_at).to eq @now
  end

  it 'cast Float to time' do
    obj = TimeObject.new(created_at: @now.to_f)
    expect(obj.created_at).to eq @now
  end

  it 'cast String to time' do
    obj = TimeObject.new(created_at: @now.to_s)
    expect(obj.created_at).to eq @now
  end
end
