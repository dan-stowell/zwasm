const std = @import("std");

pub fn main() !void {
    var args = std.process.argsWithAllocator(std.heap.page_allocator) catch |err| {
        std.debug.print("Could not create args iterator: {!}\n", .{err});
        return;
    };
    defer args.deinit();

    while (args.next()) |arg| {
        std.debug.print("arg: {s}\n", .{arg});
    }

    const module_path = "/Users/cdstowell/d/zwasm/m.wasm";
    const wasmfile = std.fs.openFileAbsolute(module_path, .{ .mode = .read_only }) catch |err| {
        std.debug.print("Could not open module path {s}: {!}", .{ module_path, err });
        return;
    };
    defer wasmfile.close();

    const stats = try wasmfile.stat();
    std.debug.print("The module file is {d} bytes\n", .{stats.size});

    var buffer: [8]u8 = undefined;
    const bytes_read = wasmfile.read(&buffer) catch |err| {
        std.debug.print("Could not read file: {!}", .{err});
        return;
    };
    std.debug.print("Read {d} bytes\n", .{bytes_read});

    const expected_magic_number = [4]u8{ 0x00, 0x61, 0x73, 0x6d };
    var matches: bool = true;
    for (buffer[0..3]) |value, index| {
        if (value == expected_magic_number[index]) {
            continue;
        } else {
            matches = false;
            break;
        }
    }
    if (matches) {
        std.debug.print("Correct magic number!\n", .{});
    } else {
        std.debug.print("Incorrect magic number!\n", .{});
    }

    const version = std.fmt.fmtSliceHexLower(buffer[4..8]);
    std.debug.print("Binary version {x}\n", .{version});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
