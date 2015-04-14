module hollow.outlets.file;

import std.stdio;
import hollow.outlets.outlet;

class FileOutlet : Outlet {
  string filePath;
  File file;

  this(string filePath) {
    this.filePath = filePath;
  };

  void open() {
    if (file.isOpen()) {
      throw new Exception("FileOutlet is already open");
    }

    this.file = File(this.filePath, "a");
  }

  void close() {
    if (!file.isOpen()) {
      throw new Exception("FileOutlet is not open");
    }

    this.file.close();
  }

  void writeLine(string line) {
    this.file.writeln(line);
  }
}

unittest {
  import std.exception;

  FileOutlet f = new FileOutlet("/tmp/hollow_test");

  // Open
  f.open();
  assertThrown(f.open());
  assert(f.file.isOpen());

  f.writeLine("TEST");

  f.close();
  assertThrown(f.close());
}

