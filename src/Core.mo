import AccountIdentifier "mo:principal/AccountIdentifier";
import Hash "mo:base/Hash";
import Result "mo:base/Result";

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
    // x0A + "tid" + canisterId + a 32 bit index.
    public type TokenIdentifier  = Text;
    
    // Represents an individual token's index within a given canister.
    public type TokenIndex = Nat32;

    public func tokenIndexHash(t : TokenIndex) : Hash.Hash { t; };

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

    public type Interface = actor {
        // Returns the balance of a requested User.
        balance    : query (request : BalanceRequest)   -> async BalanceResponse;
        // Returns an array of extensions that the canister supports.
        extensions : query ()                           -> async [Extension];
        // Transfers an given amount of tokens between two users, from and to, with an optional memo.
        transfer   : shared (request : TransferRequest) -> async TransferResponse;
    };
};
