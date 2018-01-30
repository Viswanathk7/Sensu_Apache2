#!/usr/bin/env ruby
#
# Check Total Accessess
#

require 'sensu-plugin/check/cli'

class TotalAccesses < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 10

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 5

 def run

total=0
total_accesses=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('Total Accesses')
	  	total= proc
	  	total_accesses=total.split(":")
	  	#puts total_accesses[0]
	  	#puts total_accesses[1].to_i
	  end
               end
unknown "invalid metric" if config[:crit] > 10000 or config[:warn] > 10000
            

            critical if total_accesses[1].to_i < config[:crit]
	    warning if total_accesses[1].to_i < config[:warn]
	    ok

 end
end
