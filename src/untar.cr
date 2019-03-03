require "file_utils"
require "./lib_tar/lib_tar"

class UntarException < Exception ; end

module Untar

  extend self

  def mktemp_d(prefix : String, &block)
    tempdir = File.tempname(prefix)

    Dir.mkdir tempdir

    begin
      yield tempdir
    ensure
      FileUtils.rm_rf tempdir
    end
  end

  def extract(from_file : String, to_directory : String)
    raise UntarException.new("No such file #{from_file} or file is not readable") unless File.readable?(from_file)
    raise UntarException.new("No such directory #{to_directory}") unless File.directory?(to_directory)

    open_res = Tar.open(out t, from_file, nil, Tar::O_RDONLY, 0, 0)
    raise UntarException.new("Error opening tar file: #{Errno.value}") if open_res == -1

    extract_res = Tar.extract_all(t, to_directory)
    raise UntarException.new("Error extracting tar file: #{Errno.value}") if extract_res == -1

    close_res = Tar.close(t)
    raise UntarException.new("Error closing tar file: #{Errno.value}") if close_res == -1

    nil
  end

  def extract(from_memory : IO::Memory, to_directory : String)
    mktemp_d("untar") do |tmpd|
      tarball = File.tempfile(prefix: "untar", suffix: ".tar", dir: tmpd)
      tarball.puts from_memory
      extract(tarball.path, to_directory)
    end
  end

  def extract_file(from_memory : IO::Memory, file_path : String) : IO
    mktemp_d("untar") do |tmpd|
      tarball = File.tempfile(prefix: "untar", suffix: ".tar", dir: tmpd)
      tarball.puts from_memory

      open_res = Tar.open(out t, tarball.path, nil, Tar::O_RDONLY, 0, 0)
      raise UntarException.new("Error opening tar file: #{Errno.value}") if open_res == -1

      extract_res = Tar.extract_glob(t, file_path, tmpd)
      raise UntarException.new("Error extracting tar file: #{Errno.value}") if extract_res == -1

      close_res = Tar.close(t)
      raise UntarException.new("Error closing tar file: #{Errno.value}") if close_res == -1

      mem = IO::Memory.new
      raise UntarException.new("No such file #{file_path} in the tar archive") unless File.exists?("#{tmpd}/#{file_path}")

      return mem << File.read("#{tmpd}/#{file_path}")
    end
  end

end
