module hollow.outlets.console;

import std.stdio;
import hollow.outlets.outlet;

class ConsoleOutlet : Outlet {
  void open() {}
  void close() {}

  void writeLine(string line) {
    writeln(line);
  }
}

