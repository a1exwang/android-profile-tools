#!/usr/bin/env ruby
require 'json'
def parse_cpu_usage(str)
  ret = []
  str.each_line do |line|
    if line =~ /^\d/
      pid, pr, cpu, s, thr, vss, rss, pcy, user, name = line.split
      ret << { pid: pid, cpu: cpu, name: name, user: user, nice: pr }
    end
  end
  ret
end

loop do
  File.open('/sdcard/top.txt', 'a+') do |f|
    str =`/system/bin/top -n 1 -d 2 -m 20`
    list = parse_cpu_usage(str)
    json = { type: 'log', time: Time.now.to_s, list: list }.to_json
    f.write(json)
    f.write("\n")
    puts "#{json.size} bytes written"
  end
end

