import { defineComponent, Type, World } from "@latticexyz/recs";

export function defineBlocksComponent(world: World) {
	// we need to manually define the component since lattice doesn't support u256arraybare components
	// I am using the value as Type.String since the recipe component is an int array, but they defined it as a string
	return defineComponent(
		world,
		{ value: Type.String },
		{
			id: "Blocks",
			metadata: { contractId: "component.Blocks" },
		});
}
