const std = @import("std");
const print = std.debug.print;

const tester = @import("tester.zig");
const t = &tester.default;

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

pub fn main() !void {
    try tester.setup();
    print("Starting...\n", .{});
    _ = async doBoth();
    t.run();
}
