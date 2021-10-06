import Nat32 "mo:base/Nat32";

import Ext "../src/Ext";

let tokenIds = [
    "uiocn-zqkor-uwiaa-aaaaa-cmaan-yaqca-aaaaa-a",
    "2unrm-4akor-uwiaa-aaaaa-cmaan-yaqca-aaaaa-q",
    "jqjep-sqkor-uwiaa-aaaaa-cmaan-yaqca-aaaab-a",
    "hmkxo-xakor-uwiaa-aaaaa-cmaan-yaqca-aaaab-q",
    "uvy6f-7ykor-uwiaa-aaaaa-cmaan-yaqca-aaaac-a",
    "2j3ne-2ikor-uwiaa-aaaaa-cmaan-yaqca-aaaac-q",
];

for (i in tokenIds.keys()) {
    switch (Ext.TokenIdentifier.decode(tokenIds[i])) {
        case (#err(_)) { assert(false); };
        case (#ok(_, index)) {
            assert(i == Nat32.toNat(index));
        };
    };
};
