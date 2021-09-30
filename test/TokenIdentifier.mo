import Principal "mo:base/Principal";
import Debug "mo:base/Debug";

import Ext "../src/Ext";

let c = Principal.fromText("rkp4c-7iaaa-aaaaa-aaaca-cai");
let e = Ext.TokenIdentifier.encode(c, 0);
assert(Ext.TokenIdentifier.decode(e) == #ok(c, 0));
