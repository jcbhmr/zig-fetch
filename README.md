![🚧 Under construction 👷‍♂️](https://i.imgur.com/LEP2R3N.png)

- [ ] HeadersInit sumtype
- [ ] Headers class
- [ ] XmlHttpRequestBodyInit sumtype
- [ ] BodyInit sumtype
- [ ] Body comptime usingnamespace mixin
- [ ] RequestInfo sumtype
- [ ] Request class
- [ ] RequestInit options struct
- [ ] RequestDestination enum with stringifier
- [ ] RequestMode enum with stringifier
- [ ] RequestCredentials enum with stringifier
- [ ] RequestCache enum with stringifier
- [ ] RequestRedirect enum with stringifier
- [ ] RequestDuplex enum with stringifier
- [ ] RequestPriority enum with stringifier
- [ ] Response class
- [ ] ResponseInit options struct
- [ ] ResponseType enum with stringifier
- [ ] fetch function

# Fetch API for Zig

🦓 The Fetch API for Zig

<table align=center><td>

```zig
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
```

</table>

## Installation

```sh
zig fetch --save https://github.com/jcbhmr/zig-fetch/...something
```

## Usage

```zig
const std = @import("std");
const fetch = @import("zig-fetch");

test "it works" {
    var response = try fetch.fetch(std.testing.allocator, .{ .string = "https://example.org/" }, null);
    defer response.deinit();
    const text = try response.text();
}
```

## Development
