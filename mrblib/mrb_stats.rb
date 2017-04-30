module Stats; end
module Stats::Linux; end
class Stats::Linux::Base; end
class Stats::Linux::CPU < Stats::Linux::Base; end
class Stats::Linux::Memory < Stats::Linux::Base; end
class Stats::Linux::Disk < Stats::Linux::Base; end
class Stats::Linux::Network < Stats::Linux::Base; end

module Stats
  # For now it's enough for Linux only
  CPU=Stats::Linux::CPU
  Memory=Stats::Linux::Memory
  Disk=Stats::Linux::Disk
  Network=Stats::Linux::Network
end
