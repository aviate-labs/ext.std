import Result "mo:base/Result";

import AccountIdentifier "AccountIdentifier";

module {
    // Balance refers to an amount of a particular token.
    type Balance = Nat;

    type BalanceRequest = { 
        user : User; 
        token: TokenIdentifier;
    };

    type BalanceResponse = Result.Result<Balance, CommonError>;

    type CommonError = {
        #InvalidToken : TokenIdentifier;
        #Other        : Text;
    };

    type Extension = Text;

    type Memo = Blob;

    // A unique id for a particular token and reflects the canister where the 
    // token resides as well as the index within the tokens container.
    // x0A + "tid" + canisterId + a 32 bit index.
    type TokenIdentifier  = Text;
    
    // Represents an individual token's index within a given canister.
    type TokenIndex = Nat32;

    type TransferRequest = {
        from       : User;
        to         : User;
        token      : TokenIdentifier;
        amount     : Balance;
        memo       : Memo;
        notify     : Bool;
        subaccount : ?AccountIdentifier.SubAccount;
    };

    type TransferResponse = Result.Result<Balance, {
        #Unauthorized        : AccountIdentifier.AccountIdentifier;
        #InsufficientBalance;
        #Rejected;
        #InvalidToken        : TokenIdentifier;
        #CannotNotify        : AccountIdentifier.AccountIdentifier;
        #Other               : Text;
    }>;

    type User = {
        #address   : AccountIdentifier.AccountIdentifier;
        #principal : Principal;
    };

    type Interface = actor {
        balance    : query (request : BalanceRequest)   -> async BalanceResponse;
        extensions : query ()                           -> async [Extension];
        transfer   : shared (request : TransferRequest) -> async TransferResponse;
    };
};
