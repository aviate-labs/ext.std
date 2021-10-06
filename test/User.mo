import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Ext "../src/Ext";

let p = Principal.fromText("g42pg-k3n7u-4sals-ufza4-34yrp-mmvkt-psecp-7do7x-snvq4-llwrj-2ae");
let a = Ext.AccountIdentifier.fromPrincipal(p, null);
let uA : Ext.User = #principal(p);
let uB : Ext.User = #address(a);
assert(Ext.User.equal(uA, uB));

let m = HashMap.HashMap<Ext.User, Nat>(
    0, Ext.User.equal, Ext.User.hash,
);

let u = #address("14c0f164ff9bc9ca8e458b1d6b6f79162524080dfa62ccadd0c71efa0de3db63");
m.put(#address("14c0f164ff9bc9ca8e458b1d6b6f79162524080dfa62ccadd0c71efa0de3db63"), 1);
assert(m.get(u) == ?1);
