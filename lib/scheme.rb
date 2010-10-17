require 'lib/scheme_types'
require 'lib/scheme_parser'
require 'lib/scheme_env'
require 'lib/scheme_default_env'
require 'lib/scheme_eval'

module Scheme
end

# some monkey patching
# I don't care what you think about it :)
# I've been too long into Python, now I appreciate the possibility
class NilClass
    def to_s
        "nil"
    end
end

# maybe this is a little bit too much
class String
    alias real_to_s to_s
    def to_s
        '"' + real_to_s + '"'
    end
end
