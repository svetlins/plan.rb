require 'test/unit'
require 'lib/scheme'

class TestEnvironment < Test::Unit::TestCase
    def setup
        @env = Scheme::Environment.new
        @env.set('a', 1)
    end

    def test_basic
        assert_equal(1, @env.get('a'))
        @env.set('a', 2)
        assert_equal(2, @env.get('a'))
    end

    def test_extend
        in_env = @env.extend({'stuff' => 42})

        assert_equal(1, in_env.get('a'))

        assert_equal(42, in_env.get('stuff'))
        
        in_env.set('a', 2)

        assert_equal(2, in_env.get('a'))

        assert_equal(1, @env.get('a'))
        
        assert_not_equal(42, @env.get('stuff'))

        assert_equal(nil, @env.get('stiff'))
    end
end
