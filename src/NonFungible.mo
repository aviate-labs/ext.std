import AccountIdentifier "mo:principal/AccountIdentifier";
import Result "mo:base/Result";

import Core "Core";

module {
    public type MintRequest = {
        to       : Core.User;
        metadata : ?Blob;
    };

    public type BearerResponse = Result.Result<
        AccountIdentifier.AccountIdentifier,
        Core.CommonError
    >;

    public type Interface = actor {
        bearer  : query (token : Core.TokenIdentifier) -> async BearerResponse;
        mintNFT : shared (request : MintRequest)       -> async ();
    };
};
