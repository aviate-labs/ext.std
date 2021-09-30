import Result "mo:base/Result";

// This modules follows Toniq Labs' EXT Standard.
// Lastest commit: 1f7ef3e.
module {
    public type CommonError = {
        #InvalidToken : Core.TokenIdentifier;
        #Other        : Text;
    };

    public module Core = {
        public type AccountIdentifier = Text;
        public type SubAccount        = [Nat8];

        public type Balance = Nat;

        public type BalanceRequest = { 
            user  : User; 
            token : TokenIdentifier;
        };

        public type BalanceResponse = Result.Result<
            Balance, 
            CommonError
        >;

        public type Extension = Text;

        public type Memo = Blob;

        public type TokenIdentifier = Text;

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

        public type User = {
            #address   : AccountIdentifier;
            #principal : Principal;
        };
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
            Core.Balance,
            CommonError
        >;
    };

    public module NonFungible = {
        public type BearerResponse = Result.Result<
            Core.AccountIdentifier, 
            CommonError
        >;

        public type MintRequest = {
            to       : Core.User;
            metadata : ?Blob;
        };
    };

    public module Allowance = {
        public type Request = {
            owner   : Core.User;
            spender : Principal;
            token   : Core.TokenIdentifier;
        };

        public type Response = Result.Result<
            Core.Balance,
            CommonError
        >;

        public type ApproveRequest = {
            subaccount : ?Core.SubAccount;
            spender    : Principal;
            allowance  : Core.Balance;
            token      : Core.TokenIdentifier;
        };
    };
};
