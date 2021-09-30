import Hash "mo:base/Hash";
import Hex "mo:encoding/Hex";
import RawAccountId "mo:principal/AccountIdentifier";
import Result "mo:base/Result";

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

    public type Balance = Nat;

    public type CommonError = {
        #InvalidToken : TokenIdentifier;
        #Other        : Text;
    };

    public type Extension = Text;

    public type Memo = Blob;

    public type TokenIdentifier = Text;

    public type TokenIndex = Nat32;

    public module TokenIndex = {
        public func equal(a : TokenIndex, b : TokenIndex) : Bool { a == b; };
        public func hash(a : TokenIndex) : Hash.Hash { a; };
    };

    public type User = {
        #address   : AccountIdentifier;
        #principal : Principal;
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
