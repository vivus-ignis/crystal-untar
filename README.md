# untar

[![Travis CI Build Status](https://travis-ci.org/vivus-ignis/crystal-untar.svg)](https://travis-ci.org/vivus-ignis/crystal-untar)

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
Untar.extract("archive.tar", "/tmp/archive")
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
Untar.extract(tarball, "/tmp/nginx")
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

changelog = Untar.extract_file(tarball, "nginx-1.15.9/CHANGES")

puts changelog
```

### Error handling

On errors `Untar` raises an `UntarException`.

## Contributing

1. Fork it (<https://github.com/vivus-ignis/crystal-untar/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Yaroslav Tarasenko](https://github.com/vivus-ignis) - creator and maintainer
