require "c/errno"

@[Link("tar")]
lib Tar

  O_RDONLY = 0
  O_WRONLY = 1
  TAR_GNU = 1

  # struct LibtarNode
  #   data: Void*
  #   next_: LibtarNode*
  #   prev: LibtarNode*
  # end

  # struct LibtarList
  #   first: LibtarNode*
  #   last: LibtarNode*
  #   cmpfunc: Void*
  #   flags: Int16
  #   nents: UInt16
  # end

  # struct LibtarHashptr
  #   bucket: Int16
  #   node: LibtarNode*
  # end

  # struct LibtarHash
  #   numbuckets: Int16
  #   table: Void**
  #   hashfunc: Void*
  #   nents: UInt16
  # end

  struct Header
    name: StaticArray(UInt8, 100)
    mode: StaticArray(UInt8, 8)
    uid: StaticArray(UInt8, 8)
    gid: StaticArray(UInt8, 8)
    size: StaticArray(UInt8, 12)
    mtime: StaticArray(UInt8, 12)
    chksum: StaticArray(UInt8, 8)
    typeflag: UInt8
    linkname: StaticArray(UInt8, 100)
    magic: StaticArray(UInt8, 6)
    version: StaticArray(UInt8, 2)
    uname: StaticArray(UInt8, 32)
    gname: StaticArray(UInt8, 32)
    devmajor: StaticArray(UInt8, 8)
    devminor: StaticArray(UInt8, 8)
    prefix: StaticArray(UInt8, 155)
    padding: StaticArray(UInt8, 12)
    gnu_longname: UInt8*
    gnu_longlink: UInt8*
  end

  struct TypeT
    openfunc: Void*
    closefunc: Void*
    readfunc: Void*
    writefunc: Void*
  end

  struct TAR
    type: TypeT*
    pathname: UInt8*
    fd: Int32
    oflags: Int16
    options: Int16
    th_buf: Header
    h: Void*
    th_pathname: UInt8*
  end

  # struct Dev
  # end

  fun open = "tar_open"(t : TAR**, pathname : UInt8*, type : TypeT*, oflags : Int16, mode : Int16, options : Int16) : Int16
  fun close = "tar_close"(t : TAR*) : Int16
  fun extract_all = "tar_extract_all"(t : TAR*, prefix : UInt8*) : Int16
  fun extract_glob = "tar_extract_glob"(t : TAR*, globname : UInt8*, prefix : UInt8*) : Int16

  # fun openfunc_t = "openfunc_t"(int16 : Int16) : UInt8*
  # fun readfunc_t = "readfunc_t"(int16 : Int16, void : Void*, size_t : Int16) : Int32
  # fun writefunc_t = "writefunc_t"(int16 : Int16, void : Void*, size_t : Int16) : Int32
  # fun fdopen = "tar_fdopen"(t : TAR**, fd : Int16, pathname : UInt8*, type : TypeT*, oflags : Int16, mode : Int16, options : Int16) : Int16
  # fun fd = "tar_fd"(t : TAR*) : Int16
  # fun dev_free = "tar_dev_free"(tdp : Dev*) : Void
  # fun append_file = "tar_append_file"(t : TAR*, realname : UInt8*, savename : UInt8*) : Int16
  # fun append_eof = "tar_append_eof"(t : TAR*) : Int16
  # fun append_regfile = "tar_append_regfile"(t : TAR*, realname : UInt8*) : Int16
  # fun th_read = "th_read"(t : TAR*) : Int16
  # fun th_write = "th_write"(t : TAR*) : Int16
  # fun th_get_pathname = "th_get_pathname"(t : TAR*) : UInt8*
  # fun th_get_mode = "th_get_mode"(t : TAR*) : UInt16
  # fun th_get_uid = "th_get_uid"(t : TAR*) : UInt16
  # fun th_get_gid = "th_get_gid"(t : TAR*) : UInt16
  # fun th_set_type = "th_set_type"(t : TAR*, mode : UInt16) : Void
  # fun th_set_path = "th_set_path"(t : TAR*, pathname : UInt8*) : Void
  # fun th_set_link = "th_set_link"(t : TAR*, linkname : UInt8*) : Void
  # fun th_set_device = "th_set_device"(t : TAR*, device : UInt32) : Void
  # fun th_set_user = "th_set_user"(t : TAR*, uid : UInt16) : Void
  # fun th_set_group = "th_set_group"(t : TAR*, gid : UInt16) : Void
  # fun th_set_mode = "th_set_mode"(t : TAR*, fmode : UInt16) : Void
  # fun th_set_from_stat = "th_set_from_stat"(t : TAR*, s : Void*) : Void
  # fun th_finish = "th_finish"(t : TAR*) : Void
  # fun extract_file = "tar_extract_file"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_dir = "tar_extract_dir"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_hardlink = "tar_extract_hardlink"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_symlink = "tar_extract_symlink"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_chardev = "tar_extract_chardev"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_blockdev = "tar_extract_blockdev"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_fifo = "tar_extract_fifo"(t : TAR*, realname : UInt8*) : Int16
  # fun extract_regfile = "tar_extract_regfile"(t : TAR*, realname : UInt8*) : Int16
  # fun skip_regfile = "tar_skip_regfile"(t : TAR*) : Int16
  # fun th_print = "th_print"(t : TAR*) : Void
  # fun th_print_long_ls = "th_print_long_ls"(t : TAR*) : Void
  # fun path_hashfunc = "path_hashfunc"(key : UInt8*, numbuckets : Int16) : Int16
  # fun dev_match = "dev_match"(dev1 : Void*, dev2 : Void*) : Int16
  # fun ino_match = "ino_match"(ino1 : Void*, ino2 : Void*) : Int16
  # fun dev_hash = "dev_hash"(dev : Void*) : Int16
  # fun ino_hash = "ino_hash"(inode : Void*) : Int16
  # fun mkdirhier = "mkdirhier"(path : UInt8*) : Int16
  # fun th_crc_calc = "th_crc_calc"(t : TAR*) : Int16
  # fun th_signed_crc_calc = "th_signed_crc_calc"(t : TAR*) : Int16
  # fun oct_to_int = "oct_to_int"(oct : UInt8*) : Int16
  # fun oct_to_size = "oct_to_size"() : Int16
  # fun int_to_oct_nonull = "int_to_oct_nonull"(num : Int16, oct : UInt8*, octlen : Int16) : Void
  # fun append_tree = "tar_append_tree"(t : TAR*, realdir : UInt8*, savedir : UInt8*) : Int16
end
