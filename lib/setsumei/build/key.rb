module Setsumei
  module Build
    class Key
      def Key.for(name,options = { given: [name] } )
        possible_keys = options[:given]
        direct(name,possible_keys) || lower_camel_case(name,possible_keys) || at_symbol_case(name,possible_keys) || upper_camel_case(name,possible_keys)
      end
      def Key.direct name, keys = nil
        return_if name.to_s, in: keys
      end
      def Key.lower_camel_case name, keys = nil
        lower_camel_case = name.to_s.gsub(/_[a-zA-Z]/) { |a| a[1].upcase }
        return_if lower_camel_case, in: keys
      end
      def Key.at_symbol_case name, keys = nil
        at_symbol_case = "@" + lower_camel_case(name)
        return_if at_symbol_case, in: keys
      end
      def Key.upper_camel_case name, keys = nil
        lower_camel_case = self.lower_camel_case(name)
        upper_camel_case = lower_camel_case[0].upcase + lower_camel_case[1..-1]
        return_if upper_camel_case, in: keys
      end

      private
        def self.return_if value, options = { in: [] }
          (options[:in] || [value]).select { |possible| possible == value }.first
        end
    end
  end
end
