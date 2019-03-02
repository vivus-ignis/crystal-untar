# untar

Minimalistic libtar-based library that can extract tar archives from
a file on disk or from a memory buffer.

## Installation

0. Make sure libtar is available on your system.

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     untar:
       github: vivus-ignis/crystal-untar
   ```

2. Run `shards install`

## Usage

There are two ways to use this library. Obviously, you can extract
files from a tar archive on disk:

```crystal
require "untar"

Dir.mkdir "/tmp/archive"
res = Untar.extract("archive.tar", "/tmp/archive")
puts "There was an error unpacking archive: #{res}" unless res.nil?
```

The other option is to extract files from an archive that is loaded in
a memory buffer. Consider the example below:

```crystal
require "http/client"
require "gzip"
require "untar"

response = HTTP::Client.get "https://nginx.org/download/nginx-1.15.9.tar.gz"

zipped = IO::Memory.new(response.body)
unzipped = Gzip::Reader.open(zipped) { |gzip| gzip.gets_to_end }
tarball = IO::Memory.new(unzipped)

Dir.mkdir "/tmp/nginx"
res = Untar.extract(tarball, "/tmp/nginx")
puts "There was an error unpacking archive: #{res}" unless res.nil?
```

Notice that the same `Untar.extract` method is used to unpack a
tarball on disk and in memory.

For an in-memory archive there is an additional option to only extract
a certain file. Let's pretend we want to fetch nginx changelog:

```crystal
require "http/client"
require "gzip"
require "untar"

response = HTTP::Client.get "https://nginx.org/download/nginx-1.15.9.tar.gz"
zipped = IO::Memory.new(response.body)
unzipped = Gzip::Reader.open(zipped) { |gzip| gzip.gets_to_end }
tarball = IO::Memory.new(unzipped)
res = Untar.extract_file(tarball, "nginx-1.15.9/CHANGES")
puts "There was an error unpacking archive: #{res}" unless res.is_a?(IO)

puts changelog
```

### Error handling

The approach is simple: if something went wrong during execution, an
error object is returned. For a side-effect-only `Untar.extract`
method, successful call results in a `nil` value. `Untar.extract_file`
returns an extracted file as an `IO` object when no errors occured.

Error object can be stringified for more details on what has happened.

## Contributing

1. Fork it (<https://github.com/vivus-ignis/crystal-untar/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Vivus Ignis](https://github.com/vivus-ignis) - creator and maintainer
