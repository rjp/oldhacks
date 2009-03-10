# graph parameters
width = 300
midpoint = 200

max_vol = 65535

# read a 16 bit linear raw PCM file
file = ARGV[0]
x = IO.read(file)
bytes = x.unpack("i*")
test = bytes[-100..-1]
p bytes.size
bucket_size = bytes.size / width
puts "#{bucket_size} samples in each bucket"
test.each_with_index { |i,j|
    left = i >> 16
    right = i & 0xFFFF
    puts "#{j} #{left} #{right}"
}