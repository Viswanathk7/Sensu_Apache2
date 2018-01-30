#!/usr/bin/env ruby
#
# Check Bytes Per Request
#

require 'sensu-plugin/check/cli'

class BytesPerRequest < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 1000

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 500

 def run

bytes=0
bytes_per_request=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('BytesPerReq')
	  	bytes= proc
	  	bytes_per_request=bytes.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 100000 or config[:warn] > 100000
            
            message "#{bytes_per_request[1]} BytesPerRequest returned"
            critical if bytes_per_request[1].to_i > config[:crit]
	    warning if bytes_per_request[1].to_i > config[:warn]
	    ok

 end
end
