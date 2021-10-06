import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Ext "../src/Ext";

let p = Principal.fromText("g42pg-k3n7u-4sals-ufza4-34yrp-mmvkt-psecp-7do7x-snvq4-llwrj-2ae");
let a = Ext.AccountIdentifier.fromPrincipal(p, null);
let lc = "a7218db708c35689495871c3c6860504503ab2a545630809dd8609130331b0c2";
let uc = "A7218DB708C35689495871C3C6860504503AB2A545630809DD8609130331B0C2";
assert(Ext.AccountIdentifier.equal(a, lc));
assert(Ext.AccountIdentifier.equal(a, uc));

let m = HashMap.HashMap<Ext.AccountIdentifier, Nat>(
    0, Ext.AccountIdentifier.equal, Ext.AccountIdentifier.hash,
);

m.put(lc, 1);
m.put(uc, 2);
assert(m.get(lc) == ?2);

let accountIds = [
    "afb264de8057a9ba7f79a51c80f99354004e686bb650172032aada5126e7f014",
    "43177eadc1985a577ae5fd7a93cee273364a83194df18a51961dbe262c1e159e",
    "998f670e21c3f2bd09bea1769f8b105217df8ffab4379b08d79d822d86bf9637",
    "7ee5b399a634bca2a1e83cee2422eb71893177ac19fb7d72c686770cea00d00f",
    "8917392b01d19524aec67a50bebe0d89277a498f240daef812b14e0b4d362046",
    "fc3212c5017edbe21d97e261745d221b3b68c00ebd637050b090cdd91210afce",
    "7778203e952f2a7a86990fc7f8cee48992b5fc0092eb6aa34daa321fda17de66",
    "a3c3e51da1f347966b407f0804a6f71f66210967d2bd4b32084931dcaa475e11",
];

for (accountId in accountIds.vals()) {
    m.put(accountId, 1);
};

for (accountId in accountIds.vals()) {
    switch (m.get(accountId)) {
        case (null) { assert(false); };
        case (? v) { assert(v == 1); };
    };
};
