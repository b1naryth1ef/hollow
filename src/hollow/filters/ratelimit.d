module hollow.filters.ratelimit;

import hollow.filters.filter;
import std.datetime;

class RateLimit : Filter {
  ushort mps;

  uint count;
  SysTime last;

  this (ushort mps = 10) {
    this.mps = mps;
    this.last = Clock.currTime(UTC());
  }

  bool shouldWriteLine(string line) {
    this.count += 1;

    if ((Clock.currTime(UTC()) - this.last) > dur!"seconds"(1)) {
      this.count = 0;
      this.last = Clock.currTime(UTC());
    }

    if (this.count > this.mps) {
      return false;
    }

    return true;
  }
}
