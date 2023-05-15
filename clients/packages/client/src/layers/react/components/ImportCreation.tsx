import React from "react";
import styled from "styled-components";
import { Button, CloseableContainer, Gold } from "./common";
import {OpcBlockStruct, VoxelCoordStruct} from "contracts/types/ethers-contracts/RegisterCreationSystem";

const createOpcBlock = (x:number,y:number,z:number,face:number,type:number):OpcBlockStruct => {
  return {
    relativeCoord: {
      x: x,
      y: y,
      z: z,
    } as VoxelCoordStruct,
    blockFace: face,
    blockType: type,
  } as OpcBlockStruct;
}

export const ImportCreation: React.FC<{ onClose: () => void; api: any }> = ({ onClose, api }) => {

  const registerCreation = () => {
    console.log("register creation");
    const blocks = [
      createOpcBlock(0,0,0, 0,5),
      createOpcBlock(0,1,0, 0,6),
      createOpcBlock(0,0,3, 0,10),
    ];

    api.registerCreation(blocks);
  }

  return (
    <ImportContainer onClose={onClose}>
      <p>
        <Gold>Import Creation</Gold>
      </p>
      <Buttons>
        <Button onClick={registerCreation}>Register Creation</Button>
      </Buttons>
    </ImportContainer>
  );
};

const ImportContainer = styled(CloseableContainer)`
  line-height: 1;
  pointer-events: all;
  min-width: 200px;
`;

const Buttons = styled.div`
  margin-top: 8px;
  display: grid;
  grid-gap: 9px;
  grid-auto-flow: column;
`;
