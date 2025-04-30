#!/usr/bin/env ruby
# script for a very specific use case of a directory with numbers prefixing files and wanting to rename them all in numerical order
# see revealjs slides directories where this can be used

require 'optparse'
require 'set'
require 'pry'

class ReorderDirectory

  VERSION = '1.0.0'

  def cli_options
    # default values
    @options = {interval: 1, sep: '-', directory: '.'}
    # parser
    OptionParser.new do |opts|
      opts.banner = 'Usage: reorder-dir.rb [options]'
      opts.on('-d', '--directory DIRECTORY', 'specify the directory to reorder') {|o| @options[:directory] = o}
      opts.on('-i', '--interval N', 'specify numerical interval to prefix file by') {|o| @options[:interval] = o}
      opts.on('-s', '--separator ', 'specify separator in file name') {|o| @options[:sep] = o}
      opts.on('-o', '--[no-]dry-run ', 'specify *not* to rename files') {|o| @options[:dry_run] = o}
      opts.on('-v', '--version', 'version of this script') {puts VERSION}
    end.parse!
    @options
  end

  def required_options
    exit if @options[:interval].nil? || @options[:directory].nil? || @options[:sep].nil?
  end

  def process
    required_options
    interval = @options[:interval].to_i
    all_files = Dir.entries @options[:directory]
    current_order = SortedSet.new(all_files)
    current_order.each_with_index do |file, index|
      if file.include? @options[:sep]
        file_frags = file.to_s.partition @options[:sep]
        next unless file_frags.first.is_i?
        file_frags.first.replace("%03d" % (index * interval)) if !file_frags.last.empty?
        new_file = file_frags.join('')
        if @options[:dry_run] then
          puts new_file
        else
          File.rename(file, new_file)
        end
      end
    end
    new_entries = Dir.entries @options[:directory]
    print_set('post-process', current_order, new_entries)  unless @options[:dry_run]
  end


  def print_set(header, before_set, after_set)
    puts "*** #{header} ***"
    before_set.each_with_index {|file,index | puts "#{file} ==> #{after_set[index]}"}
  end

end # end class


## monkey patch string to have a is_i? method
class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end


ro = ReorderDirectory.new
opts = ro.cli_options
puts "processing with the following options: #{opts}"

ro.process