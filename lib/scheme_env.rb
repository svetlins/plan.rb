module Scheme
    class Environment
        def initialize(parent=nil)
            @hash = {}
            @parent = parent
        end

        def get(key)
            @hash[key] or (@parent and @parent.get(key))
        end

        def set(key, val)
            @hash[key] = val
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
