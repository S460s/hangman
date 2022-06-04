#!/usr/bin/env ruby

def new_path(file_path)
  "#{File.split(file_path)[0]}/filtered_ #{File.basename(file_path)}"
end

def word_filter
  min = ARGV[0].to_i
  max = ARGV[1].to_i
  file_path = ARGV[2]

  throw "No such file: #{file_path}" unless File.exist?(file_path)

  filtered_file = File.new(new_path(file_path), 'w')

  if File.exist?(filtered_file)
    puts 'There is already a filtered file. Shutting down..'
    return
  end

  File.open(file_path, 'r') do |file|
    file.each_line { |line| filtered_file.puts line.chomp if line.chomp.length.between?(min, max) }
  end

  filtered_file.close
end

word_filter
