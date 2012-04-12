

module RubyEXR
		
		
	MAGIC = 0x01312f76
	COMPRESSION = ['NO','RLE','ZIPS','ZIP','PIZ','PXR24','B44','B44A']
	LINEORDER = ['INCRESING Y','DECREASING Y','RANDOM Y']
	PIXELTYPE = ['UINT','HALF','FLOAT']
	
	COMPRESSION_NONE = 0
	COMPRESSION_RLE = 1
	COMPRESSION_ZIPS = 2
	COMPRESSION_ZIP = 3
	COMPRESSION_PIZ = 4
	COMPRESSION_PXR24 = 5
	COMPRESSION_B44 = 6
	COMPRESSION_B44A = 7
	
	LINEORDER_INCREASING_Y = 0
	LINEORDER_DECREASING_Y = 1
	LINEORDER_RANDOM_Y = 2
	
	PIXELTYPE_UINT = 0
	PIXELTYPE_HALF = 1
	PIXELTYPE_FLOAT = 2
	
	class Channel
		@@dot = '.'
		
		
		def initialize(name='', type=PIXELTYPE_HALF, x_sampling=1, y_sampling=1, p_linear=false)
			@name = name
			@type = type
			@x_sampling = x_sampling
			@y_sampling = y_sampling
			@p_linear = p_linear
		end
		
		attr_reader :name
		attr_reader :type
		attr_reader :x_sampling
		attr_reader :y_sampling
		attr_reader :p_linear
		
		def to_s
			"Channel(#{@name}, #{PIXELTYPE[@type]}, #{@x_sampling}, #{@y_sampling}, #{@p_linear})"
		end
		
		def == (other)
			@name == other.name
		end
		
		def compatible?(rhs)
			@type == rhs.type && 
			@x_sampling == rhs.x_sampling &&
			@y_sampling == rhs.y_sampling &&
			@p_linear == rhs.p_linear
		end
		
		def layer
			i = @name.rindex @@dot
			return @name unless i
			@name[0...i]
		end
		
		def suffix
			i = @name.rindex @@dot
			return "" unless i
			@name[i+1..-1]
		end
		
		
	end
	
	class ChannelArray < Array
		
		
		def layers
			map do |c| c.layer end.uniq!
			# yeah, this is why it ... 
			#return list(set(map(self, lambda c: c.layer)))
		end
		
		def default_channels
			select do |c| c.layer.size == 0 end
		end
		
		def channels_with_prefix prefix
			# select do |c| c.name.start_with? prefix end
			s = index {|c| c.name.start_with? prefix}
			return Array.new() unless s
			
			e = size
			for i in s...e
				if !at(i).name.start_with? prefix
					e = i
					break
				end
			end
			slice(s...e)
		end
		
	end
	
	class Header
		
		@@null = "\0"
		
		# initialize ourself with an optional file stream
		def initialize(stream=nil)
			@header = Hash.new
			if stream
				read stream
			end
		end
		
		
		
		# Interface
		def attribute(name)
			attribute_info name[1]
		end
		
		# Returns a list of [attr_type_name, data] for the given attribute name
		# Nil is returned if the attribute doesn't exist in the header.
		def attribute_info(name)
			@header[name]
		end
		
		def attributes
			@header.keys
		end
		
		
		def read stream
			@header = Hash.new
			
			read_int_32 = lambda { stream.read(4).unpack("V").at 0 }
			read_cstring = lambda do
				out = ""
				c = stream.read(1)
				while c and c != @@null
					out += c
					c = stream.read(1)
				end
				raise IOError, "unexpected eof while reading c string" if stream.eof
				return out
			end
			
			id = read_int_32.call
			version = read_int_32.call
			
			if id != MAGIC 
				raise TypeError, "Invalid magic number: #{id} should be #{MAGIC}"
			end
			
			until stream.eof
				attr_name = read_cstring.call
				# happens if we see the 0 that terminates the header
				break if attr_name.size == 0
				type_name = read_cstring.call
				size = read_int_32.call
				data = stream.read size
				
				if size == 0 or data.size != size
					raise IOError, "unexpected end of file while reading datablock of #{attr_name}"
				end
				
				@header[attr_name] = [type_name, _parse_data(data)]
			end
		end
		
		# end interface
		
		# utilities
		
		def _parse_data data
			
		end
		
		# end utilities
		
	end # class header
end # end module ruby_exr
