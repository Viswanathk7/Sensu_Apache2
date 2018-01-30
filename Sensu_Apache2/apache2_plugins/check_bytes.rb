#!/usr/bin/env ruby
#
# Check Bytes Per Second
#

require 'sensu-plugin/check/cli'

class BytesPerSecond < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 100

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 50

 def run

bytes=0
bytes_per_second=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('BytesPerSec')
	  	bytes= proc
	  	bytes_per_second=bytes.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 10000 or config[:warn] > 10000
            
            message "#{bytes_per_second[1]} BytesPerSecond returned"
            critical if bytes_per_second[1].to_i > config[:crit]
	    warning if bytes_per_second[1].to_i > config[:warn]
	    ok

 end
end
