import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Ext "../src/Ext";

let tokenIds = [
    "uiocn-zqkor-uwiaa-aaaaa-cmaan-yaqca-aaaaa-a",
    "2unrm-4akor-uwiaa-aaaaa-cmaan-yaqca-aaaaa-q",
    "jqjep-sqkor-uwiaa-aaaaa-cmaan-yaqca-aaaab-a",
    "hmkxo-xakor-uwiaa-aaaaa-cmaan-yaqca-aaaab-q",
    "uvy6f-7ykor-uwiaa-aaaaa-cmaan-yaqca-aaaac-a",
    "2j3ne-2ikor-uwiaa-aaaaa-cmaan-yaqca-aaaac-q",
];
let canisterId = Principal.fromText("uwroj-kaaaa-aaaaj-qabxa-cai");

for (i in tokenIds.keys()) {
    assert(Ext.TokenIdentifier.encode(canisterId, Nat32.fromNat(i)) == tokenIds[i]);
    switch (Ext.TokenIdentifier.decode(tokenIds[i])) {
        case (#err(_)) { assert(false); };
        case (#ok(_, index)) {
            assert(i == Nat32.toNat(index));
        };
    };
};

let c = Principal.fromText("rkp4c-7iaaa-aaaaa-aaaca-cai");
let e = Ext.TokenIdentifier.encode(c, 0);
assert(Ext.TokenIdentifier.decode(e) == #ok(c, 0));

let xc = Principal.fromText("rkp4c-7iaaa-aaaaa-aaaca-cai");
let xe = Ext.TokenIdentifier.encode(xc, 1234);
assert(Ext.TokenIdentifier.decode(xe) == #ok(xc, 1234));
