module Scheme
    class Environment
        attr_reader :bindings

        def initialize(parent=nil)
            @bindings = {}
            @parent = parent
        end

        def get(key)
          result = @bindings[key] || (@parent && @parent.get(key))

          raise NameError, "Unexistent binding: #{key}" if result.nil?

          result
        end

        def set(key, val)
            @bindings[key] = val
        end

        def extend(new_bindings)
            new_env = Environment.new(self)

            new_bindings.entries.each do |key, value|
                new_env.set(key, value)
            end
            
            return new_env
        end
    end
end
