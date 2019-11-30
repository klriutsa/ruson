class Time
  def self.new(value)
    Time.at(value).to_datetime
  end
end
