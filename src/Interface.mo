import Ext "Ext";

module {
    // A basic token interface, used for f.e. ERC20 tokens.
    // Contains the minimal interface for a fungible token.
    public type FungibleToken = actor {
        // [@ext:core]

        // Returns the balance of a requested User.
        balance    : query (request : Ext.Core.BalanceRequest)   -> async Ext.Core.BalanceResponse;
        // Returns an array of extensions that the canister supports.
        // Should be at least ["@ext:common"].
        extensions : query ()                                    -> async [Ext.Extension];
        // Transfers an given amount of tokens between two users, from and to, with an optional memo.
        transfer   : shared (request : Ext.Core.TransferRequest) -> async Ext.Core.TransferResponse;

        // [@ext:common]

        // Returns the metadata of the token.
        metadata : query (tokenId : Ext.TokenIdentifier) -> async Ext.Common.MetadataResponse;
        // Returns the total supply of the token.
        supply   : query (tokenId : Ext.TokenIdentifier) -> async Ext.Common.SupplyResponse;
    };

    // A basic nft interface, used for f.e. ERC721 tokens.
    // Contains the minimal interface for a non fungible token.
    public type NonFungibleToken = actor {
        // [@ext:core]

        // Returns the balance of a requested User.
        balance    : query (request : Ext.Core.BalanceRequest)   -> async Ext.Core.BalanceResponse;
        // Returns an array of extensions that the canister supports.
        // Should be at least ["@ext:common", "@ext:nonfungible", "@ext:allowance"].
        extensions : query ()                                    -> async [Ext.Extension];
        // Transfers an given amount of tokens between two users, from and to, with an optional memo.
        transfer   : shared (request : Ext.Core.TransferRequest) -> async Ext.Core.TransferResponse;

        // [@ext:common]

        // Returns the metadata of the given token.
        metadata : query (token : Ext.TokenIdentifier) -> async Ext.Common.MetadataResponse;
        // Returns the total supply of the token.
        supply   : query (token : Ext.TokenIdentifier) -> async Ext.Common.SupplyResponse;

        // [@ext:nonfungible]

        // Returns the account that is linked to the given token.
        bearer  : query (token : Ext.TokenIdentifier)            -> async Ext.NonFungible.BearerResponse;
        // Mints a new NFT and assignes its owner to the given User.
        mintNFT : shared (request : Ext.NonFungible.MintRequest) -> async Ext.NonFungible.MintResponse;

        // [@ext:allowance]

        // Returns the amount which the given spender is allowed to withdraw from the given owner.
        allowance : query (request : Ext.Allowance.Request)         -> async Ext.Allowance.Response;
        // Allows the given spender to withdraw from your account multiple times, up to the given allowance.
        approve   : shared (request : Ext.Allowance.ApproveRequest) -> async ();
    };
};
