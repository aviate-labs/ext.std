import Array "mo:base/Array";
import Array_ "mo:array/Array";
import Base32 "mo:encoding/Base32";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import CRC32 "mo:hash/CRC32";
import Hash "mo:base/Hash";
import Hex "mo:encoding/Hex";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Principal "mo:principal/Principal";
import RawAccountId "mo:principal/AccountIdentifier";
import Result "mo:base/Result";
import Text "mo:base/Text";

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
     
        public func encode(canisterId : Principal, tokenIndex : TokenIndex) : Text {
            let rawTokenId = Array.flatten<Nat8>([
                prefix,
                Blob.toArray(Principal.toBlob(canisterId)),
                Binary.BigEndian.fromNat32(tokenIndex),
            ]);
            
            Principal.toText(Principal.fromBlob(Blob.fromArray(rawTokenId)));
        };

        public func decode(tokenId : TokenIdentifier) : Result.Result<(Principal, TokenIndex), Text> {
            let bs = Blob.toArray(Principal.toBlob(Principal.fromText(tokenId)));
            let (rawPrefix, rawToken) = Array_.split(bs, 4);
            if (rawPrefix != prefix) return #err("invalid prefix");
            let (rawCanister, rawIndex) = Array_.split(rawToken, rawToken.size() - 4 : Nat);
            #ok(
                Principal.fromBlob(Blob.fromArray(rawCanister)),
                Binary.BigEndian.toNat32(rawIndex),
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

        public type MintResponse = Result.Result<
           TokenIndex,
           CommonError
        >;
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
