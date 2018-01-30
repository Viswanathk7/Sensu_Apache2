#!/usr/bin/env ruby
#
# Check Request per second
#

require 'sensu-plugin/check/cli'

class RequestPerSecond < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 10

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 5

 def run

request=0
request_per_second=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('ReqPerSec')
	  	request= proc
	  	request_per_second=request.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 10000 or config[:warn] > 10000
            
            message "#{request_per_second[1]} RequestPerSecond returned" 
            critical if request_per_second[1].to_i > config[:crit] or request_per_second[1].to_i == config[:crit]
	    warning if request_per_second[1].to_i > config[:warn] or request_per_second[1].to_i ==config[:warn]
	    ok

 end
end
