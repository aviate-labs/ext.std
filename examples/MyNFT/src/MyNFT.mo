import Ext "mo:ext/Ext";
import Interface "mo:ext/Interface";

shared({caller = owner}) actor class NFT() : async Interface.NonFungibleToken = {
    // TODO: implement endpoints.

    // @ext:core
    public query func balance(request : Ext.Core.BalanceRequest) : async Ext.Core.BalanceResponse {
        #err(#Other("not implemented"));
    };

    public query func extensions() : async [Ext.Extension] {
        ["@ext:common"];
    };

    public shared({caller}) func transfer(request : Ext.Core.TransferRequest) : async Ext.Core.TransferResponse {
        #err(#Other("not implemented"));
    };

    // @ext:common
    public query func metadata(token : Ext.TokenIdentifier) : async Ext.Common.MetadataResponse {
        #err(#Other("not implemented"));
    };

    public query func supply(token : Ext.TokenIdentifier) : async Ext.Common.SupplyResponse {
        #err(#Other("not implemented"));
    };

    // @ext:nonfungible
    public query func bearer(token : Ext.TokenIdentifier) : async Ext.NonFungible.BearerResponse {
        #err(#Other("not implemented"));
    };

    public shared func mintNFT(request : Ext.NonFungible.MintRequest) : async () {
        // TODO
    };

    // @ext:allowance
    public query func allowance(request : Ext.Allowance.Request) : async Ext.Allowance.Response {
        #err(#Other("not implemented"));
    };

    public shared func approve(request : Ext.Allowance.ApproveRequest) : async () {
        // TODO
    };
};
