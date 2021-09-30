import Ext "Ext";

module {
    // A basic token interface, used for f.e. ERC20 tokens.
    // Contains the minimal interface for a fungible token.
    public type FungibleToken = actor {
        // @ext:core
        balance    : query (request : Ext.Core.BalanceRequest)   -> async Ext.Core.BalanceResponse;
        extensions : query ()                                    -> async [Ext.Extension];
        transfer   : shared (request : Ext.Core.TransferRequest) -> async Ext.Core.TransferResponse;

        // @ext:common
        metadata : query (token : Ext.TokenIdentifier) -> async Ext.Common.MetadataResponse;
        supply   : query (token : Ext.TokenIdentifier) -> async Ext.Common.SupplyResponse;
    };

    // A basic nft interface, used for f.e. ERC721 tokens.
    // Contains the minimal interface for a non fungible token.
    public type NonFungibleToken = actor {
        // @ext:core
        balance    : query (request : Ext.Core.BalanceRequest)   -> async Ext.Core.BalanceResponse;
        extensions : query ()                                    -> async [Ext.Extension];
        transfer   : shared (request : Ext.Core.TransferRequest) -> async Ext.Core.TransferResponse;

        // @ext:common
        metadata : query (token : Ext.TokenIdentifier) -> async Ext.Common.MetadataResponse;
        supply   : query (token : Ext.TokenIdentifier) -> async Ext.Common.SupplyResponse;

        // @ext:nonfungible
        bearer  : query (token : Ext.TokenIdentifier)            -> async Ext.NonFungible.BearerResponse;
        mintNFT : shared (request : Ext.NonFungible.MintRequest) -> async ();

        // @ext:allowance
        allowance : query (request : Ext.Allowance.Request)         -> async Ext.Allowance.Response;
        approve   : shared (request : Ext.Allowance.ApproveRequest) -> async ();
    };
};
