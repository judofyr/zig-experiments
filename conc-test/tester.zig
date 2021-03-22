const std = @import("std");

pub var default: Tester = undefined;

pub fn setup() !void {
    default = Tester.init(std.heap.c_allocator);
}

pub const Tester = struct {
    const Self = @This();

    frames: std.ArrayList(anyframe),
    prng: std.rand.DefaultPrng,

    pub fn init(alloc: *std.mem.Allocator) Self {
        var seed: u64 = undefined;
        std.os.getrandom(std.mem.asBytes(&seed)) catch unreachable;

        return Self{
            .frames = std.ArrayList(anyframe).init(alloc),
            .prng = std.rand.DefaultPrng.init(seed),
        };
    }

    pub fn wait(self: *Self) void {
        suspend {
            self.frames.append(@frame()) catch unreachable;
        }
    }

    pub fn runOnce(self: *Self) bool {
        const len = self.frames.items.len;
        if (len == 0) return false;
        const i = self.prng.random.intRangeLessThan(usize, 0, len);
        resume self.frames.orderedRemove(i);
        return true;
    }

    pub fn run(self: *Self) void {
        while (true) {
            const didRun = self.runOnce();
            if (!didRun) break;
        }
    }
};
