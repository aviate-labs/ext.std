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

    public type MetadataResponse = Result.Result<
        Metadata,
        Core.CommonError
    >;

    public type SupplyResponse = Result.Result<
        Core.Balance,
        Core.CommonError
    >;

    public type Inferface = actor {
        metadata   : query (token : Core.TokenIdentifier) -> async MetadataResponse;
        supply     : query (token : Core.TokenIdentifier) -> async SupplyResponse;
    };
};
