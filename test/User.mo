import Principal "mo:base/Principal";

import Ext "../src/Ext";

let p = Principal.fromText("g42pg-k3n7u-4sals-ufza4-34yrp-mmvkt-psecp-7do7x-snvq4-llwrj-2ae");
let a = Ext.AccountIdentifier.fromPrincipal(p, null);
let uA : Ext.User = #principal(p);
let uB : Ext.User = #address(a);
assert(Ext.User.equal(uA, uB));
