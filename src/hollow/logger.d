module hollow.logger;

import std.string;
import hollow.outlets.outlet;
import hollow.outlets.console;
import hollow.formatters.formatter;
import hollow.filters.filter;

class Logger {
  string name;

  Outlet[] outlets;
  Filter[] filters;
  Formatter formatter;

  this(string name) {
    this.name = name;

    this.formatter = new Formatter(this.name);
  }

  this(string name, Outlet outlet) {
    this.name = name;
    this.formatter = new Formatter(this.name);
    this.outlets ~= outlet;
  }

  void addOutlet(Outlet outlet) {
    outlet.open();
    this.outlets ~= outlet;
  }

  void addFilter(Filter filter) {
    this.filters ~= filter;
  }

  void close() {
    foreach (i, outlet; this.outlets) {
      outlet.close();
    }
  }

  void write(string line) {
    foreach (i, filter; this.filters) {
      if (!filter.shouldWriteLine(line)) {
        return;
      }
    }

    foreach (i, outlet; this.outlets) {
      outlet.writeLine(line);
    }
  }

  void TRACE(T...)(Throwable t, string fmt, T args) {
    string data = format(fmt, args) ~ ":\n" ~ t.toString();

    this.write(this.formatter.format("EXCEPTION", data));
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

  void ERROR(T...)(string fmt, T args) {
    this.write(this.formatter.format("ERROR", format(fmt, args)));
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
  log.DEBUG("test %s, %s, %s", 1, "LOL", log);
  log.WARNING("test %s, %s, %s", 1, "LOL", log);
  log.ERROR("test %s, %s, %s", 1, "LOL", log);

  try {
    throw new Exception("test");
  } catch (Exception e) {
    log.TRACE(e, "test %s, %s, %s", 1, "LOL", log);
  }
}

