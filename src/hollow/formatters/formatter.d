module hollow.formatters.formatter;

import std.string;
import std.datetime;

class Formatter {
  string loggerName;

  this(string loggerName) {
    this.loggerName = loggerName;
  }

  string format(string level, string logLine) {
    return std.string.format("[%s] (%s) %s: %s",
        this.loggerName,
        Clock.currTime().toISOExtString(),
        level,
        logLine);
  }
}

