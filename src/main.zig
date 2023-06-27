const std = @import("std");

pub fn main() !void {
    const module_path = "/Users/cdstowell/d/zwasm/m.wasm";
    const wasmfile = std.fs.openFileAbsolute(module_path, .{ .mode = .read_only }) catch |err| {
        std.debug.print("Could not open module path {s}: {!}", .{ module_path, err });
        return;
    };
    const stats = try wasmfile.stat();
    std.debug.print("The module file is {d} bytes\n", .{stats.size});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
