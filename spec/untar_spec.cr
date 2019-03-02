require "./spec_helper"
require "file_utils"

TEST_ARCHIVE = "./spec/test-data/doc.tar"
GZIPPED_ARCHIVE = "./spec/test-data/doc.tar.gz"
TEST_DIR = ".test"


describe Untar do

  Spec.before_each do
    Dir.mkdir_p TEST_DIR
    FileUtils.cp TEST_ARCHIVE, TEST_DIR
  end

  Spec.after_each do
    FileUtils.rm_rf TEST_DIR
  end

  it "extracts from a tar file to an existing directory" do
    res = Untar.extract(from_file: TEST_ARCHIVE,
                        to_directory: TEST_DIR)
    res.should be_nil
  end

  it "extracts from a tar file to an existing directory" do
    res = Untar.extract(from_file: TEST_ARCHIVE,
                        to_directory: TEST_DIR)
    File.exists? ".test/doc/th_read.3"
    File.exists? ".test/doc/Makefile.in"
    Dir.entries(".test/doc")
      .reject { |f| f == "." || f == ".."}
      .size
      .should eq 11
  end

  it "returns an error when extracting from a tar file to a non-existing directory" do
    res = Untar.extract(from_file: TEST_ARCHIVE,
                        to_directory: ".non-existent")
    res.should be_a(Untar::Error)
  end

  it "returns an error when extracting a gzipped tar file" do
    res = Untar.extract(from_file: GZIPPED_ARCHIVE,
                        to_directory: TEST_DIR)
    res.should be_a(Untar::Error)
  end

  it "extracts from memory to an existing directory" do
    mem = IO::Memory.new
    mem << File.read(TEST_ARCHIVE)
    res = Untar.extract(from_memory: mem,
                        to_directory: TEST_DIR)

    res.should be_nil
    File.exists? ".test/doc/th_read.3"
    File.exists? ".test/doc/Makefile.in"
    Dir.entries(".test/doc")
      .reject { |f| f == "." || f == ".."}
      .size
      .should eq 11
  end

  it "extracts particular file from memory to memory" do
    mem = IO::Memory.new
    mem << File.read(TEST_ARCHIVE)
    res = Untar.extract_file(from_memory: mem,
                             file_path: "doc/tar_open.3")

    res.should be_a(IO::Memory)
    res.to_s.should contain("\\fBtar_open\\fP() will fail if:")
  end

  it "extracts nonexistent file from memory returns an error" do
    mem = IO::Memory.new
    mem << File.read(TEST_ARCHIVE)
    res = Untar.extract_file(from_memory: mem,
                             file_path: "doc/nonexistent")

    res.should be_a(Untar::Error)
  end

end
