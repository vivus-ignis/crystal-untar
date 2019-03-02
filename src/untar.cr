require "uuid"
require "file_utils"
require "./untar/tar.cr"

class Dir

  def self.tempdir(prefix : String, &block)
    random_name = "#{prefix}.#{UUID.random.to_s.split("-").last}"
    tempdir = File.join(Dir.tempdir, random_name)

    Dir.mkdir tempdir

    begin
      yield tempdir
    ensure
      FileUtils.rm_rf tempdir
    end
  end

end

module Untar

  extend self

  struct Error
    property message : String
    def initialize(@message); end
  end

  def extract(from_file : String, to_directory : String) : Untar::Error | Nil
    return Error.new("No such file #{from_file} or file is not readable") unless File.readable?(from_file)
    return Error.new("No such directory #{to_directory}") unless File.directory?(to_directory)

    open_res = Tar.open(out t, from_file, nil, Tar::O_RDONLY, 0, 0)
    return Error.new("Error opening tar file: #{Errno.value}") if open_res == -1

    extract_res = Tar.extract_all(t, to_directory)
    return Error.new("Error extracting tar file: #{Errno.value}") if extract_res == -1

    close_res = Tar.close(t)
    return Error.new("Error closing tar file: #{Errno.value}") if close_res == -1

    nil
  end

  def extract(from_memory : IO::Memory, to_directory : String) : Untar::Error | Nil
    Dir.tempdir("untar") do |tmpd|
      tarball = File.tempfile(prefix: "untar", suffix: ".tar", dir: tmpd)
      tarball.puts from_memory
      extract(tarball.path, to_directory)
    end

    nil
  end

  def extract_file(from_memory : IO::Memory, file_path : String) : IO | Untar::Error
    Dir.tempdir("untar") do |tmpd|
      tarball = File.tempfile(prefix: "untar", suffix: ".tar", dir: tmpd)
      tarball.puts from_memory

      open_res = Tar.open(out t, tarball.path, nil, Tar::O_RDONLY, 0, 0)
      return Error.new("Error opening tar file: #{Errno.value}") if open_res == -1

      extract_res = Tar.extract_glob(t, file_path, tmpd)
      return Error.new("Error extracting tar file: #{Errno.value}") if extract_res == -1

      close_res = Tar.close(t)
      return Error.new("Error closing tar file: #{Errno.value}") if close_res == -1

      mem = IO::Memory.new
      return Error.new("No such file #{file_path} in the tar archive") unless File.exists?("#{tmpd}/#{file_path}")

      return mem << File.read("#{tmpd}/#{file_path}")
    end
  end

end
