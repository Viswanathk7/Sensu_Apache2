#!/usr/bin/env ruby
#
# Check Disk Usage
#

require 'sensu-plugin/check/cli'

class DiskUsage < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 500

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 500
def run
procs = `du -sh /var/log/apache2/`
usage =procs.split(' ')
strlength=usage[0].length
size= usage[0].split(/\D/)
unknown "invalid metric" if config[:crit] > 100000 or config[:warn] > 100000
            
            message "#{usage[0]} occupied"
            critical if size[0].to_i == config[:crit] or ("G".ord) == usage[0][strlength-1].ord 
	    warning if size[0].to_i == config[:warn]  or ("M".ord) == usage[0][strlength-1].ord
	    ok if usage[0][strlength-1].ord == ("K".ord) 

 end
end
