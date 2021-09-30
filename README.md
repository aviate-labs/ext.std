# Extendable Token Standard

| **Table of Contents**

- [Usage](#usage)
  - [Vessel](#vessel)
  - [Interfaces](#interfaces)

## Usage

### Vessel

1. Run `vessel init` to create the config files.
2. Import this package.

#### Example Config

##### `vessel.dhall`

```dhall
{
  dependencies = [ "base", "std" ],
  compiler = None Text
}
```

##### `package-set.dhall`

```dhall
let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.7-20210818/package-set.dhall sha256:c4bd3b9ffaf6b48d21841545306d9f69b57e79ce3b1ac5e1f63b068ca4f89957
let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }

let additions = [
  { name = "std"
  , repo = "https://github.com/aviate-labs/ext.std"
  , version = "v0.1.0"
  , dependencies = ["base", "principal"]
  },
  -- See examples/ for the complete file.
] : List Package

in  upstream # additions
```

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
