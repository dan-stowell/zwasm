const std = @import("std");

pub fn main() !void {
    const module_path = "/Users/cdstowell/d/zwasm/m.wasm";
    const wasmfile = std.fs.openFileAbsolute(module_path, .{ .mode = .read_only }) catch |err| {
        std.debug.print("Could not open module path {s}: {!}", .{ module_path, err });
        return;
    };
    defer wasmfile.close();

    const stats = try wasmfile.stat();
    std.debug.print("The module file is {d} bytes\n", .{stats.size});

    var buffer: [4]u8 = undefined;
    const bytes_read = wasmfile.read(&buffer) catch |err| {
        std.debug.print("Could not read file: {!}", .{err});
        return;
    };
    std.debug.print("Read {d} bytes\n", .{bytes_read});
    if ((0x0061 == buffer[0]) and (0x736d == buffer[1])) {
        std.debug.print("Correct magic number!\n", .{});
    } else {
        std.debug.print("Incorrect magic number!\n", .{});
    }
    const version = buffer[2];
    std.debug.print("Binary version {x}\n", .{version});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
