class Time
  def self.new(value)
    case value
    when Integer, Float
      Time.at(value).to_time
    when String
      Time.parse(value).to_time
    else
      value
    end
  end
end
