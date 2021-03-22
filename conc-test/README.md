# Concurrent, randomized tester

This demonstrates a basic *concurrent tester*:
Inside of `async` code you add calls to `t.wait()`.
The moment every `async` call is waiting then the system will pick one randomly to resume.
As you run this code multiple times it will test for different interleavings of concurrent calls.
This can help finding concurrency bugs.

In practice, the randomized approach may not best, but this demonstrates how *easy* it is to implement in Zig.

## Example

Code:

```zig
fn doA() void {
    t.wait();
    print("A start\n", .{});
    t.wait();
    print("A end\n", .{});
}

fn doB() void {
    t.wait();
    print("B start\n", .{});
    t.wait();
    print("B end\n", .{});
}

fn doBoth() void {
    print("Both start\n", .{});
    var a = async doA();
    var b = async doB();
    await a;
    await b;
    print("Both end\n", .{});
}
```

Two possible outputs:

```
$ zig run conc-test/main.zig
Both start
B start
B end
A start
A end
Both end

$ zig run conc-test/main.zig
Both start
B start
A start
A end
B end
Both end
```
