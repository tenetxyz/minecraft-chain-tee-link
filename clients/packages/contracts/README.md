# Reference Implementation Contracts

### Upgrading Facets

Run `yarn hardhat:deploy:upgrade` to only upgrade Diamond contracts.

### Adding new functions

When adding new facets or new functions to existing facets, make sure to add the function selectors in `src/test/utils/Deploy.sol`.

### Adding new Systems or Components

Modify deploy.json and run `yarn mud codegen-libdeploy --out src/test` to regenerate the LibDeploy.sol test script
How to run a single test: `yarn mud test --forgeOpts='-m testRegisterCreation'`
How to run a test in debugger mode: `yarn mud test --forgeOpts='-m testRegisterCreation --debug testRegisterCreation()'`
NOTE: the function you specify int he --debug MUST be in the test file (not from a function it depends on, cause it can't see the source code for that function)