# Extendable Token Standard

| **Table of Contents**

- [Usage](#usage)
  - [Vessel](#vessel)
  - [Interfaces](#interfaces)

## Usage

### Vessel

1. Run `vessel init` to create the config files.
2. Import this package.

You can find an example configurations in one of the [`example`](./examples) directories.

#### Type Checking

```shell
$(dfx cache show)/moc $(vessel sources) -r MyToken.mo
```

### Interfaces

You can use the predefined interfaces to check whether you have implemented al the required methods.

```motoko
import Ext "mo:std/EXT/Ext";
import Interface "mo:std/EXT/Interface";

shared({caller = owner}) actor class Token() : async Interface.FungibleToken = {
    // ...
};
```

### References

- [Toniq Labs' EXT Standard](https://github.com/Toniq-Labs/extendable-token)
