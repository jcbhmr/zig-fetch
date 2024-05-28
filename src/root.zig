const std = @import("std");
const testing = std.testing;

const StringStringTuple = struct { []const u8, []const u8 };

pub const HeadersInit = union(enum) {
    slice: [][][]const u8,
    hashMap: std.StringHashMap([]const u8),
};

pub const Headers = struct {
    allocator: std.mem.Allocator,
    headerList: std.ArrayList(StringStringTuple),

    pub fn init(allocator: std.mem.Allocator, init2: ?HeadersInit) !Headers {
        var self = Headers{ .allocator = allocator, .headerList = std.ArrayList(StringStringTuple).init(allocator) };
        if (init2) |init3| {
            switch (init3) {
                .slice => |slice| {
                    for (slice) |s| {
                        try self.headerList.append(.{ s[0], s[1] });
                    }
                },
                .hashMap => |hashMap| {
                    var iterator2 = hashMap.iterator();
                    while (iterator2.next()) |e| {
                        const name = e.key_ptr.*;
                        const value = e.value_ptr.*;
                        try self.headerList.append(.{ name, value });
                    }
                },
            }
        }
        return self;
    }

    pub fn deinit(self: *Headers) void {
        self.headerList.deinit();
    }

    pub fn append(self: *Headers, name: []const u8, value: []const u8) !void {
        try self.headerList.append(.{ name, value });
    }

    const Iterator = struct {
        headers: *Headers,
        index: usize = 0,

        pub fn next(self: *Iterator) ?StringStringTuple {
            if (self.index >= self.headers.headerList.items.len) {
                return null;
            } else {
                const oldIndex = self.index;
                self.index += 1;
                return self.headers.headerList.items[oldIndex];
            }
        }
    };

    pub fn iterator(self: *Headers) Iterator {
        return Iterator{ .headers = self };
    }
};

pub const Response = struct {
    pub fn deinit(self: *Response) void {
        _ = self;
    }
};

pub fn fetch(allocator: std.mem.Allocator) !Response {
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();
    const headers = std.http.Client.Request.Headers{
        .accept_encoding = .default,
    };
    var extra_headers_list = std.ArrayList(std.http.Header).init(allocator);
    defer extra_headers_list.deinit();
    try extra_headers_list.append(.{ .name = "Hello-World", .value = "Wow!" });
    var response_storage_dynamic = std.ArrayList(u8).init(allocator);
    defer response_storage_dynamic.deinit();
    const result = try client.fetch(.{
        .location = .{ .url = "https://example.org/" },
        .headers = headers,
        .extra_headers = extra_headers_list.items,
        .method = std.http.Method.GET,
        .response_storage = .{ .dynamic = &response_storage_dynamic },
    });
    std.debug.print("{any}\n", .{result});
    std.debug.print("{s}\n", .{response_storage_dynamic.items});
    return Response{};
}

test "fetch(\"https://jsonplaceholder.typicode.com/todos/1\")" {
    const Todo = struct {
        userId: i64,
        id: i64,
        title: []const u8,
        completed: bool,
    };
    var response = try fetch(testing.allocator, .{ .string = "https://jsonplaceholder.typicode.com/todos/1" }, null);
    defer response.deinit();
    const parsed = try response.json(Todo);
    defer parsed.deinit();
    const todo = parsed.value;
    std.debug.print("{any}", .{todo});
}
