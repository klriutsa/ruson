module Ruson
  class Boolean
    def self.new(value)
      return value if value.kind_of?(TrueClass) || value.kind_of?(FalseClass)

      case value
      when 'true'
        return true
      when 'false'
        return false
      else
        return false
      end
    end
  end
end