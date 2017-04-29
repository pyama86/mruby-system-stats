
c = Stats::CPU.new
m = Stats::Linux::Memory.new
puts Stats::Linux::CPU.current
puts Stats::Linux::Memory.current

sleep 5
puts c.average
puts m.average
