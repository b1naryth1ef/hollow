# hollow
Hollow is logging for D-lang that attempts to be simple, lightweight while remaining extensive and useable.

```d
import hollow.logger;

Logger myLog = newLogger("myLog");

myLog.INFO("This is a test %s", 1);
myLog.DEBUG("Ohai");
```
