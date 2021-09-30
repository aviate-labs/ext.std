import Array "mo:base/Array";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import Hash "mo:base/Hash";
import Hex "mo:encoding/Hex";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Principal "mo:principal/Principal";
import RawAccountId "mo:principal/AccountIdentifier";
import Result "mo:base/Result";
import Text "mo:base/Text";

import util "mo:principal/util";

// This modules follows Toniq Labs' EXT Standard.
// Lastest commit: 1f7ef3e.
module {
    public type AccountIdentifier = Text;
    public type SubAccount        = [Nat8];

    public module AccountIdentifier = {
        public func equal(a : AccountIdentifier, b : AccountIdentifier) : Bool {
            let aRaw = switch (Hex.decode(a)) {
                case (#err(_)) { assert(false); []; };
                case (#ok(aR)) { aR; };
            };
            let bRaw = switch (Hex.decode(b)) {
                case (#err(_)) { assert(false); []; };
                case (#ok(bR)) { bR; };
            };
            RawAccountId.equal(aRaw, bRaw);
        };

        public func hash(a : AccountIdentifier) : Hash.Hash {
            let aRaw = switch (Hex.decode(a)) {
                case (#err(_)) { assert(false); []; };
                case (#ok(aR)) { aR; };
            };
            RawAccountId.hash(aRaw);
        };

        public func fromPrincipal(p : Principal, subAccount : ?SubAccount) : AccountIdentifier {
            RawAccountId.toText(RawAccountId.fromPrincipal(p, subAccount));
        };
    };

    // Balance refers to an amount of a particular token.
    public type Balance = Nat;

    public type CommonError = {
        #InvalidToken : TokenIdentifier;
        #Other        : Text;
    };

    public type Extension = Text;

    // Represents a 'payment' memo which can be attached to a transaction.
    public type Memo = Blob;

    // A unique id for a particular token and reflects the canister where the 
    // token resides as well as the index within the tokens container.
    public type TokenIdentifier = Text;

    public module TokenIdentifier = {
        private let prefix : [Nat8] = [10, 116, 105, 100]; // \x0A "tid"

        // Encodes the given canister id and token index into a token identifier.
        // \x0A + "tid" + canisterId + token index
        public func encode(canisterId : Principal, tokenIndex : TokenIndex) : TokenIdentifier {
            let rawTokenId = Array.flatten<Nat8>([
                prefix,
                Blob.toArray(Principal.toBlob(canisterId)),
                Binary.BigEndian.fromNat32(tokenIndex),
            ]);
            Text.fromIter(Iter.fromArray(
                Array.map<Nat8, Char>(
                    rawTokenId,
                    func (n : Nat8) : Char {
                        Char.fromNat32(Nat32.fromNat(Nat8.toNat(n)));
                    },
                ),
            ));
        };

        // Decodes the given token identifier into the underlying canister id and token index.
        public func decode(tokenId : TokenIdentifier) : Result.Result<(Principal, TokenIndex), Text> {
            var err : ?Text = null;
            var bs = Array.map<Char, Nat8>(
                Iter.toArray(tokenId.chars()),
                func (c : Char) : Nat8 {
                    let n = Char.toNat32(c);
                    if (127 < n) {
                        err := ?"invalid non-ascii character";
                        return 0;
                    };
                    Nat8.fromNat(Nat32.toNat(n));
                },
            );
            switch (err) {
                case (? e)  { return #err(e); };
                case (null) {
                    if (bs.size() < 8) return #err("too short");
                };
            };
            bs := util.drop<Nat8>(bs, 4);
            let canisterId = util.take<Nat8>(bs, bs.size() - 4);
            bs := util.drop<Nat8>(bs, bs.size() - 4);
            #ok(
                Principal.fromBlob(Blob.fromArray(canisterId)),
                Binary.BigEndian.toNat32(bs),
            );
        };
    };

    // Represents an individual token's index within a given canister.
    public type TokenIndex = Nat32;

    public module TokenIndex = {
        public func equal(a : TokenIndex, b : TokenIndex) : Bool { a == b; };

        public func hash(a : TokenIndex) : Hash.Hash { a; };
    };

    public type User = {
        #address   : AccountIdentifier;
        #principal : Principal;
    };

    public module User = {
        public func equal(a : User, b : User) : Bool {
            let aAddress = toAccountIdentifier(a);
            let bAddress = toAccountIdentifier(b);
            AccountIdentifier.equal(aAddress, bAddress);
        };

        public func hash(u : User) : Hash.Hash {
            AccountIdentifier.hash(toAccountIdentifier(u));
        };

        public func toAccountIdentifier(u : User) : AccountIdentifier {
            switch (u) {
                case (#address(address)) { address; };
                case (#principal(principal)) {
                    AccountIdentifier.fromPrincipal(principal, null);
                };
            };
        };
    };

    public module Core = {
        public type BalanceRequest = { 
            user  : User; 
            token : TokenIdentifier;
        };

        public type BalanceResponse = Result.Result<
            Balance,
            CommonError
        >;

        public type TransferRequest = {
            from       : User;
            to         : User;
            token      : TokenIdentifier;
            amount     : Balance;
            memo       : Memo;
            notify     : Bool;
            subaccount : ?SubAccount;
        };

        public type TransferResponse = Result.Result<Balance, {
            #Unauthorized : AccountIdentifier;
            #InsufficientBalance;
            #Rejected;
            #InvalidToken : TokenIdentifier;
            #CannotNotify : AccountIdentifier;
            #Other        : Text;
        }>;
    };

    public module Common = {
        public type Metadata = {
            #fungible : {
                name     : Text;
                symbol   : Text;
                decimals : Nat8;
                metadata : ?Blob;
            };

            #nonfungible : {
                metadata : ?Blob;
            };
        };

        public type MetadataResponse = Result.Result<
            Metadata,
            CommonError
        >;

        public type SupplyResponse = Result.Result<
            Balance,
            CommonError
        >;
    };

    public module NonFungible = {
        public type BearerResponse = Result.Result<
            AccountIdentifier, 
            CommonError
        >;

        public type MintRequest = {
            to       : User;
            metadata : ?Blob;
        };
    };

    public module Allowance = {
        public type Request = {
            owner   : User;
            spender : Principal;
            token   : TokenIdentifier;
        };

        public type Response = Result.Result<
            Balance,
            CommonError
        >;

        public type ApproveRequest = {
            subaccount : ?SubAccount;
            spender    : Principal;
            allowance  : Balance;
            token      : TokenIdentifier;
        };
    };
};
