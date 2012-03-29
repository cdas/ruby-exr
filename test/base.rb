
# adjust path to include our library folder
# then make all packages available
libroot = File.join(File.dirname(__FILE__), '..', 'lib')
$:.push libroot unless $:.include? libroot

require 'ruby_exr'
require 'test/unit'


# Simple base class for all our unit tests in case we want to make ammendments
# *note*:: we explicitly don't patch the basic TestCase class to keep things more 
# obvious
class TestBase < Test::Unit::TestCase
	# just there to get no default test maybe ?
	def test_nothing
	end
	
	def fixture_path(name)
		File.join(File.dirname(__FILE__), 'fixtures', name)
	end
	
end # class TestBase


