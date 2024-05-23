const std = @import("std");
const testing = std.testing;

const HeaderListItem = struct {
    name: []const u8,
    value: []const u8,
};

pub const Headers = struct {
    allocator: std.mem.Allocator,
    headerList: std.ArrayList(HeaderListItem),

    pub fn append(h: *Headers, name: []const u8, value: []const u8) void {
        h.headerList.append(HeaderListItem{ .name = name, .value = value }) catch @panic("Allocator.Error");
    }
};

test "Headers append()" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var headers = Headers{
        .allocator = allocator,
        .headerList = std.ArrayList(HeaderListItem).init(allocator),
    };
    headers.append("Content-Type", "text/html; charset=UTF-8");
}

export fn fetch(a: i32, b: i32) i32 {
    return a + b;
}
