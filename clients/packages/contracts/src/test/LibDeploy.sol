// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.0;

// NOTE: This file is autogenerated via `mud codegen-libdeploy` from `deploy.json`. Do not edit manually.

// Foundry
import { DSTest } from "ds-test/test.sol";
import { console } from "forge-std/console.sol";

// Solecs 
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { World } from "solecs/World.sol";
import { IComponent } from "solecs/interfaces/IComponent.sol";
import { getAddressById } from "solecs/utils.sol";
import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { ISystem } from "solecs/interfaces/ISystem.sol";

// Components (requires 'components=...' remapping in project's remappings.txt)
import { GameConfigComponent, ID as GameConfigComponentID } from "components/GameConfigComponent.sol";
import { ItemPrototypeComponent, ID as ItemPrototypeComponentID } from "components/ItemPrototypeComponent.sol";
import { ItemComponent, ID as ItemComponentID } from "components/ItemComponent.sol";
import { PositionComponent, ID as PositionComponentID } from "components/PositionComponent.sol";
import { OwnedByComponent, ID as OwnedByComponentID } from "components/OwnedByComponent.sol";
import { RecipeComponent, ID as RecipeComponentID } from "components/RecipeComponent.sol";
import { OccurrenceComponent, ID as OccurrenceComponentID } from "components/OccurrenceComponent.sol";
import { StakeComponent, ID as StakeComponentID } from "components/StakeComponent.sol";
import { ClaimComponent, ID as ClaimComponentID } from "components/ClaimComponent.sol";
import { NameComponent, ID as NameComponentID } from "components/NameComponent.sol";
import { CreationComponent, ID as CreationComponentID } from "components/BlocksComponent.sol";
import { ActivatedCreationsComponent, ID as ActivatedCreationsComponentID } from "components/ActivatedCreationsComponent.sol";

// Systems (requires 'systems=...' remapping in project's remappings.txt)
import { ComponentDevSystem, ID as ComponentDevSystemID } from "systems/ComponentDevSystem.sol";
import { BulkSetStateSystem, ID as BulkSetStateSystemID } from "systems/BulkSetStateSystem.sol";
import { MineSystem, ID as MineSystemID } from "systems/MineSystem.sol";
import { BuildSystem, ID as BuildSystemID } from "systems/BuildSystem.sol";
import { CreativeBuildSystem, ID as CreativeBuildSystemID } from "systems/CreativeBuildSystem.sol";
import { CraftSystem, ID as CraftSystemID } from "systems/CraftSystem.sol";
import { OccurrenceSystem, ID as OccurrenceSystemID } from "systems/OccurrenceSystem.sol";
import { StakeSystem, ID as StakeSystemID } from "systems/StakeSystem.sol";
import { BulkStakeSystem, ID as BulkStakeSystemID } from "systems/BulkStakeSystem.sol";
import { ClaimSystem, ID as ClaimSystemID } from "systems/ClaimSystem.sol";
import { TransferSystem, ID as TransferSystemID } from "systems/TransferSystem.sol";
import { BulkTransferSystem, ID as BulkTransferSystemID } from "systems/BulkTransferSystem.sol";
import { NameSystem, ID as NameSystemID } from "systems/NameSystem.sol";
import { InitSystem, ID as InitSystemID } from "systems/InitSystem.sol";
import { Init2System, ID as Init2SystemID } from "systems/Init2System.sol";
import { RegisterCreationSystem, ID as RegisterCreationSystemID } from "systems/RegisterCreationSystem.sol";
import { ActivateCreationSystem, ID as ActivateCreationSystemID } from "systems/ActivateCreationSystem.sol";

struct DeployResult {
  IWorld world;
  address deployer;
}

library LibDeploy {
  function deploy(
    address _deployer,
    address _world,
    bool _reuseComponents
  ) internal returns (DeployResult memory result) {
    result.deployer = _deployer;

    // ------------------------
    // Deploy 
    // ------------------------

    // Deploy world
    result.world = _world == address(0) ? new World() : IWorld(_world);
    if (_world == address(0)) result.world.init(); // Init if it's a fresh world

    // Deploy components
    if (!_reuseComponents) {
      IComponent comp;

      console.log("Deploying GameConfigComponent");
      comp = new GameConfigComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying ItemPrototypeComponent");
      comp = new ItemPrototypeComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying ItemComponent");
      comp = new ItemComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying PositionComponent");
      comp = new PositionComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying OwnedByComponent");
      comp = new OwnedByComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying RecipeComponent");
      comp = new RecipeComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying OccurrenceComponent");
      comp = new OccurrenceComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying StakeComponent");
      comp = new StakeComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying ClaimComponent");
      comp = new ClaimComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying NameComponent");
      comp = new NameComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying CreationComponent");
      comp = new CreationComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying ActivatedCreationsComponent");
      comp = new ActivatedCreationsComponent(address(result.world));
      console.log(address(comp));
    } 
    
    // Deploy systems 
    deploySystems(address(result.world), true);
  }
  
  function authorizeWriter(
    IUint256Component components,
    uint256 componentId,
    address writer
  ) internal {
    IComponent(getAddressById(components, componentId)).authorizeWriter(writer);
  }
  
  /**
   * Deploy systems to the given world.
   * If `init` flag is set, systems with `initialize` setting in `deploy.json` will be executed.
   */
  function deploySystems(
    address _world,
    bool init
  ) internal {
    IWorld world = IWorld(_world);
    // Deploy systems
    ISystem system; 
    IUint256Component components = world.components();

    console.log("Deploying ComponentDevSystem");
    system = new ComponentDevSystem(world, address(components));
    world.registerSystem(address(system), ComponentDevSystemID);
    authorizeWriter(components, GameConfigComponentID, address(system));
    authorizeWriter(components, ItemPrototypeComponentID, address(system));
    authorizeWriter(components, ItemComponentID, address(system));
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, OwnedByComponentID, address(system));
    authorizeWriter(components, RecipeComponentID, address(system));
    authorizeWriter(components, OccurrenceComponentID, address(system));
    authorizeWriter(components, StakeComponentID, address(system));
    authorizeWriter(components, ClaimComponentID, address(system));
    authorizeWriter(components, NameComponentID, address(system));
    authorizeWriter(components, CreationComponentID, address(system));
    authorizeWriter(components, ActivatedCreationsComponentID, address(system));
    console.log(address(system));

    console.log("Deploying BulkSetStateSystem");
    system = new BulkSetStateSystem(world, address(components));
    world.registerSystem(address(system), BulkSetStateSystemID);
    authorizeWriter(components, GameConfigComponentID, address(system));
    authorizeWriter(components, ItemPrototypeComponentID, address(system));
    authorizeWriter(components, ItemComponentID, address(system));
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, OwnedByComponentID, address(system));
    authorizeWriter(components, RecipeComponentID, address(system));
    authorizeWriter(components, OccurrenceComponentID, address(system));
    authorizeWriter(components, StakeComponentID, address(system));
    authorizeWriter(components, ClaimComponentID, address(system));
    authorizeWriter(components, NameComponentID, address(system));
    authorizeWriter(components, CreationComponentID, address(system));
    authorizeWriter(components, ActivatedCreationsComponentID, address(system));
    console.log(address(system));

    console.log("Deploying MineSystem");
    system = new MineSystem(world, address(components));
    world.registerSystem(address(system), MineSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, OwnedByComponentID, address(system));
    authorizeWriter(components, ItemComponentID, address(system));
    console.log(address(system));

    console.log("Deploying BuildSystem");
    system = new BuildSystem(world, address(components));
    world.registerSystem(address(system), BuildSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, OwnedByComponentID, address(system));
    console.log(address(system));

    console.log("Deploying CreativeBuildSystem");
    system = new CreativeBuildSystem(world, address(components));
    world.registerSystem(address(system), CreativeBuildSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, ItemComponentID, address(system));
    console.log(address(system));

    console.log("Deploying CraftSystem");
    system = new CraftSystem(world, address(components));
    world.registerSystem(address(system), CraftSystemID);
    authorizeWriter(components, OwnedByComponentID, address(system));
    authorizeWriter(components, ItemComponentID, address(system));
    console.log(address(system));

    console.log("Deploying OccurrenceSystem");
    system = new OccurrenceSystem(world, address(components));
    world.registerSystem(address(system), OccurrenceSystemID);
    console.log(address(system));

    console.log("Deploying StakeSystem");
    system = new StakeSystem(world, address(components));
    world.registerSystem(address(system), StakeSystemID);
    authorizeWriter(components, StakeComponentID, address(system));
    authorizeWriter(components, OwnedByComponentID, address(system));
    console.log(address(system));

    console.log("Deploying BulkStakeSystem");
    system = new BulkStakeSystem(world, address(components));
    world.registerSystem(address(system), BulkStakeSystemID);
    authorizeWriter(components, StakeComponentID, address(system));
    authorizeWriter(components, OwnedByComponentID, address(system));
    console.log(address(system));

    console.log("Deploying ClaimSystem");
    system = new ClaimSystem(world, address(components));
    world.registerSystem(address(system), ClaimSystemID);
    authorizeWriter(components, ClaimComponentID, address(system));
    console.log(address(system));

    console.log("Deploying TransferSystem");
    system = new TransferSystem(world, address(components));
    world.registerSystem(address(system), TransferSystemID);
    authorizeWriter(components, OwnedByComponentID, address(system));
    console.log(address(system));

    console.log("Deploying BulkTransferSystem");
    system = new BulkTransferSystem(world, address(components));
    world.registerSystem(address(system), BulkTransferSystemID);
    authorizeWriter(components, OwnedByComponentID, address(system));
    console.log(address(system));

    console.log("Deploying NameSystem");
    system = new NameSystem(world, address(components));
    world.registerSystem(address(system), NameSystemID);
    authorizeWriter(components, NameComponentID, address(system));
    console.log(address(system));

    console.log("Deploying InitSystem");
    system = new InitSystem(world, address(components));
    world.registerSystem(address(system), InitSystemID);
    authorizeWriter(components, GameConfigComponentID, address(system));
    authorizeWriter(components, ItemPrototypeComponentID, address(system));
    authorizeWriter(components, OccurrenceComponentID, address(system));
      if(init) system.execute(new bytes(0));
    console.log(address(system));

    console.log("Deploying Init2System");
    system = new Init2System(world, address(components));
    world.registerSystem(address(system), Init2SystemID);
    authorizeWriter(components, RecipeComponentID, address(system));
      if(init) system.execute(new bytes(0));
    console.log(address(system));

    console.log("Deploying RegisterCreationSystem");
    system = new RegisterCreationSystem(world, address(components));
    world.registerSystem(address(system), RegisterCreationSystemID);
    authorizeWriter(components, CreationComponentID, address(system));
    console.log(address(system));

    console.log("Deploying ActivateCreationSystem");
    system = new ActivateCreationSystem(world, address(components));
    world.registerSystem(address(system), ActivateCreationSystemID);
    authorizeWriter(components, ActivatedCreationsComponentID, address(system));
    console.log(address(system));
  }
}
