module hollow.logger;

import std.string;
import hollow.outlets.outlet;
import hollow.outlets.console;
import hollow.formatters.formatter;

class Logger {
  string name;

  Outlet[] outlets;
  Formatter formatter;

  this(string name) {
    this.name = name;

    this.formatter = new Formatter(this.name);
  }

  void addOutlet(Outlet outlet) {
    outlet.open();
    this.outlets ~= outlet;
  }

  void close() {
    foreach (i, outlet; this.outlets) {
      outlet.close();
    }
  }

  void write(string line) {
    foreach (i, outlet; this.outlets) {
      outlet.writeLine(line);
    }
  }

  void INFO(T...)(string fmt, T args) {
    this.write(this.formatter.format("INFO", format(fmt, args)));
  }

  void DEBUG(T...)(string fmt, T args) {
    this.write(this.formatter.format("DEBUG", format(fmt, args)));
  }

  void WARNING(T...)(string fmt, T args) {
    this.write(this.formatter.format("WARNING", format(fmt, args)));
  }

}

Logger newLogger(string name) {
  Logger log = new Logger(name);
  log.addOutlet(new ConsoleOutlet());
  return log;
}

unittest {
  import hollow.outlets.file;

  Logger log = new Logger("test");
  FileOutlet f = new FileOutlet("/tmp/hollow_test");
  log.addOutlet(f);

  log.INFO("test %s, %s, %s", 1, "LOL", log);
}

