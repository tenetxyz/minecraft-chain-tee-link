import React from "react";
import styled from "styled-components";
import { Button, CloseableContainer, Gold } from "./common";

export const ImportCreation: React.FC<{ onClose: () => void }> = ({ onClose }) => {
  return (
    <ImportContainer onClose={onClose}>
      <p>
        <Gold>Import Creation</Gold>
      </p>
      <Buttons>
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
