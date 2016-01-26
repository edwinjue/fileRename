#!/usr/bin/env ruby

class FileUtil
  @file_list = []
  @dup_list = []
  @amb_list = []
  
  def self.output_list(heading,list)
    puts
    puts "+" + heading.capitalize
    p list
  end

  def self.report
    output_list "Processed files (#{@file_list.count}):", @file_list
    output_list "Ambiguous files (#{@amb_list.count}):", @amb_list
    output_list "Duplicate files (#{@dup_list.count}):", @dup_list
    puts
    puts "Total processed: #{@file_list.count}, Total ambiguous: #{@amb_list.count}, Total duplicates: #{@dup_list.count}"
    puts
  end

  def self.fixExt(file)
    return if file == __FILE__

    new_file = file.dup
    if file.index(".").nil? && !file.rindex('_').nil? 
      new_file[file.rindex('_')] = '.'

      #process fix
      system(`which mv`.chomp,'--',file,new_file)
    end

  end

  def self.find_and_remove(str,file)

  end

  def self.rename(file,new_file)
    return if file == __FILE__

    #check for ambiguous filename
    if new_file[0] == '.'
      puts "ambiguous filename found, skipping: #{file}"
      @amb_list << file
    else
    
      #check for duplicates
      if @file_list.any?{|f| f == new_file}
        puts "duplicate found, skipping: #{file}"
        @dup_list << file
      else
        #process rename
        system(`which mv`.chomp,'--', file, new_file)
        @file_list << new_file
      end
    end   
  end
end

#rename files
files = Dir.glob(["*.jpg","*.mp4","*.m4v"])
files.each{ |file|
  new_file = file.gsub(/[é]+/,'e')
                 .gsub(/[á]+/,'a')
                 .gsub(/[á]+/,'a')
                 .gsub(/[â]+/,'a')
                 .gsub(/[ỏ]+/,'o')
                 .gsub(/[à]+/,'a')
                 .gsub(/[^A-Za-z0-9._-]/,'_')
                 .gsub(/[_]+/,'_')
                 .gsub(/^[_]+/,'')

  FileUtil.rename(file,new_file)
}

FileUtil.report

#fix missing ext (e.g. filename_mp4 => filename.mp4)
=begin
 files = Dir.glob("*")
 files.each{ |file|
  FileUtil.fixExt(file)
 }
=end
