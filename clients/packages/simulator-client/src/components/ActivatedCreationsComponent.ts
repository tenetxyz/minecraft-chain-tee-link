import { defineComponent, Type, World } from "@latticexyz/recs";

export function defineActivatedCreationsComponent(world: World) {
	return defineComponent(world, {
		activatedCreations: Type.T, // TODO: I'm not sure how we can turn this type into ana rray of blocks
	},{
		id: "ActivatedCreations",
		metadata: { contractId: "component.ActivatedCreations" },
	});
}
