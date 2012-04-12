require File.join(File.dirname(__FILE__), 'base')


class TestExrHeader < TestBase
	
	def test_initialization
		h = RubyEXR::Header.new
		
		# verify an empty, uninitialized instance throws proper exceptions
		assert(h.attribute_info(:nonexisting) == nil, "should get nil for nonexisting attr")
		assert(h.attributes.size == 0, "should have no attributes yet")
	end
	
	def test_channel
		c = RubyEXR::Channel.new
		assert ! c != c
		
		assert c.compatible? c
		assert c.to_s == "Channel(, HALF, 1, 1, false)"
		assert c == RubyEXR::Channel.new
		
		#Layer examples
		[['layer', 'layer', ''],
		 ['lay.g', 'lay',   'g'],
		 ['m.l.b', 'm.l',   'b'],
		 ['.r',    '',      'r'],
		 [''     , ''   ,   '' ]].each do |name, layer, suffix|
		 	 c = RubyEXR::Channel.new(name)
		 	 assert c.layer == layer
		 	 assert c.suffix == suffix
		 end
		 
	 end # test_channel
	
	 def test_channelarray
	 	 a = RubyEXR::ChannelArray.new
	 	 
	 	 File.open(fixture_path "channel_names.list").each_line do |line|
	 	 	 a.push RubyEXR::Channel.new line
	 	 end
	 	 assert a.size > 0
	 	 
	 	 # layers()
	 	 l = a.layers
	 	 assert l.size < a.size
	 	 assert l.uniq! == nil
	 	 
	 	 df = a.default_channels
	 	 assert df.size > 0 and df.at(0).is_a(RubyEXR::Channel)
	 	 assert df.size == 3
	 	 
	 	 # middle
	 	 prefix = 'beauty.'
	 	 assert a.channels_with_prefix(prefix).size == 4
	 	 
	 	 prefix = 'doesnt exist'
	 	 assert a.channels_with_prefix(prefix).size == 0
	 	 
	 	 # end position
	 	 prefix = 'velocity'
	 	 assert a.channels_with_prefix(prefix).size == 3
	 	 
	 end
	 
	 def test_header
	 	 Dir.glob(fixture_path "*.exr").each do |f|
	 	 	 h = RubyEXR::Header.new(File.open f)
	 	 end
	 	 # Dir.glob "fixtures/*.exr"
	 end
end #
