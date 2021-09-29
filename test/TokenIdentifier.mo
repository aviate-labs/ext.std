import Principal "mo:base/Principal";

import Core "../src/Core";

let p = Principal.fromText("aaaaa-aa");
let tokenId = {
    canisterId = p;
    index      = 0 : Core.TokenIndex;
};

let et = Core.TokenIdentifier.encode(tokenId);
assert(et == [10, 116, 105, 100, 0, 0, 0, 0]);
assert(Core.TokenIdentifier.decode(et) == #ok(tokenId));

let tt = Core.TokenIdentifier.toText(tokenId);
assert(tt == "00000000");
assert(Core.TokenIdentifier.toText({
    canisterId = p;
    index      = 1 : Core.TokenIndex;
}) == "00000001");

assert(Core.TokenIdentifier.fromText("00000000") == #ok(tokenId));
