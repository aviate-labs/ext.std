import AccountIdentifier "mo:principal/AccountIdentifier";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Binary "mo:encoding/Binary";
import CRC32 "mo:principal/CRC32";
import Hash "mo:base/Hash";
import Hex "mo:encoding/Hex";
import Nat32 "mo:base/Nat32";
import Principal "mo:principal/Principal";
import Principal_ "mo:base/Principal";
import Result "mo:base/Result";
import SHA256 "mo:sha/SHA256";
import Text "mo:base/Text";

import P "mo:base/Prelude";
import Debug "mo:base/Debug";

import util "mo:principal/util";

module {
    // Balance refers to an amount of a particular token.
    public type Balance = Nat;

    public type BalanceRequest = {
        user : User; 
        token: TokenIdentifier;
    };

    public type BalanceResponse = Result.Result<Balance, CommonError>;

    public type CommonError = {
        #InvalidToken : TokenIdentifier;
        #Other        : Text;
    };

    public type Extension = Text;

    // Represents a "payment" memo/data which can be attached to a transaction.
    public type Memo = Blob;

    // A unique id for a particular token and reflects the canister where the 
    // token resides as well as the index within the tokens container.
    public type TokenIdentifier = {
        canisterId : Principal;
        index      : TokenIndex;
    };

    // \x0A + "tid" + canisterId + token index
    public type RawTokenIdentifier = [Nat8]; // Size 4 + 0-29 + 4

    public module TokenIdentifier = {
        private let prefix : [Nat8] = [10, 116, 105, 100]; // \x0A + "tid"

        public func decode(rawTokenId : RawTokenIdentifier) : Result.Result<TokenIdentifier, Text> {
            var bs = rawTokenId;
            if (bs.size() < 8) return #err("too short");

            let bsPrefix = util.take<Nat8>(bs, 4);
            bs := util.drop<Nat8>(bs, 4);
            if (bsPrefix != prefix) return #err("invalid prefix");

            let bsCanister = util.take<Nat8>(bs, bs.size() - 4);
            bs := util.drop<Nat8>(bs, bs.size() - 4);
            let canisterId = Principal.fromBlob(Blob.fromArray(bsCanister));

            #ok({
                canisterId;
                index = Binary.BigEndian.toNat32(bs);
            })
        };

        public func encode(tokenId : TokenIdentifier) : RawTokenIdentifier {
            Array.flatten<Nat8>([
                prefix,
                Blob.toArray(Principal.toBlob(tokenId.canisterId)),
                Binary.BigEndian.fromNat32(tokenId.index),
            ]);
        };

        public func equal(a : TokenIdentifier, b : TokenIdentifier) : Bool {
            Principal_.equal(a.canisterId, b.canisterId) and Nat32.equal(a.index, b.index);
        };

        public func hash(tokenId : TokenIdentifier) : Hash.Hash {
            CRC32.checksum(Array.append<Nat8>(
                Blob.toArray(Principal.toBlob(tokenId.canisterId)),
                Binary.BigEndian.fromNat32(tokenId.index),
            ));
        };

        public func toText(tokenId : TokenIdentifier) : Text {
            Hex.encode(Array.append<Nat8>(
                Blob.toArray(Principal.toBlob(tokenId.canisterId)),
                Binary.BigEndian.fromNat32(tokenId.index),
            ));
        }
    };
    
    // Represents an individual token's index within a given canister.
    public type TokenIndex = Nat32;

    public module TokenIndex = {
        public func equal(a : TokenIndex, b : TokenIndex) : Bool {
            Nat32.equal(a, b);
        };

        public func hash(i : TokenIndex) : Hash.Hash {
            i;
        };
    };

    public type TransferRequest = {
        from       : User;
        to         : User;
        token      : TokenIdentifier;
        amount     : Balance;
        memo       : Memo;
        notify     : Bool;
        subaccount : ?AccountIdentifier.SubAccount;
    };

    public type TransferResponse = Result.Result<Balance, {
        #Unauthorized        : AccountIdentifier.AccountIdentifier;
        #InsufficientBalance;
        #Rejected;
        #InvalidToken        : TokenIdentifier;
        #CannotNotify        : AccountIdentifier.AccountIdentifier;
        #Other               : Text;
    }>;

    public type User = {
        #address   : AccountIdentifier.AccountIdentifier;
        #principal : Principal;
    };

    public module User = {
        public func toAccountIdentifier(u : User) : AccountIdentifier.AccountIdentifier {
            switch (u) {
                case (#address(address)) { address; };
                case (#principal(principal)) {
                    AccountIdentifier.fromPrincipal(principal, null);
                };
            };
        };

        public func equal(a : User, b : User) : Bool {
            let aAddress = toAccountIdentifier(a);
            let bAddress = toAccountIdentifier(b);
            AccountIdentifier.equal(aAddress, bAddress);
        };

        public func hash(u : User) : Hash.Hash {
            AccountIdentifier.hash(toAccountIdentifier(u));
        };
    };

    public type Interface = actor {
        // Returns the balance of a requested User.
        balance    : query (request : BalanceRequest)   -> async BalanceResponse;
        // Returns an array of extensions that the canister supports.
        extensions : query ()                           -> async [Extension];
        // Transfers an given amount of tokens between two users, from and to, with an optional memo.
        transfer   : shared (request : TransferRequest) -> async TransferResponse;
    };
};
