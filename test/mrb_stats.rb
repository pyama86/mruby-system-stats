#
# Stats Test
#

assert("Stats::CPU.current") do
  h = Stats::CPU.current
  assert_true h.is_a?(Hash)
end

assert("Stats::Memory.current") do
  h = Stats::Memory.current
  assert_true h.is_a?(Hash)
end
