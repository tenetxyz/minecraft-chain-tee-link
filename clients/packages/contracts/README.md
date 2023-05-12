# Reference Implementation Contracts

### Upgrading Facets

Run `yarn hardhat:deploy:upgrade` to only upgrade Diamond contracts.

### Adding new functions

When adding new facets or new functions to existing facets, make sure to add the function selectors in `src/test/utils/Deploy.sol`.

### Adding new Systems or Components

Modify deploy.json and run `yarn mud codegen-libdeploy --out src/test` to regenerate the LibDeploy.sol test script