require 'active_record'

module CommaAsDecimalSeparator 

    def type_cast(value)
        separator = ","
        if type == :decimal && value.is_a?(String)
            value = value.gsub(separator, '.').to_d
        end
        super(value)
    end

end

ActiveRecord::Type::Value.send(:prepend, CommaAsDecimalSeparator)