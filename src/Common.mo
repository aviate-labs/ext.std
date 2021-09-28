import Result "mo:base/Result";

import Core "Core";

module {
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

    public type Inferface = actor {
        metadata   : shared query (token : Core.TokenIdentifier) -> async Result.Result<Metadata, Core.CommonError>;
        supply     : shared query (token : Core.TokenIdentifier) -> async Result.Result<Core.Balance, Core.CommonError>;
    };
};
