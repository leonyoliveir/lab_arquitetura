module controller(input logic [5:0] op, funct,  
                  input logic zero, clk, reset, 
                  output logic memtoreg, memwrite,
                  output logic pcsrc, pcen, alusrcA,
                  output logic [1:0] alusrcB,
                  output logic regdst, regwrite, iord,
                  output logic jump, pcwrite, irwrite,
                  output logic [2:0] alucontrol);
                  
  logic [1:0] aluop;
  logic branch;
  
  maindec md(op, zero, clk, reset, memtoreg, memwrite, branch, alusrcA, alusrcB, regdst, regwrite, iord, jump, pcwrite, irwrite, aluop, pcsrc);
  
  aludec ad(funct, aluop, alucontrol);
  
  assign pcen = (branch & zero) | pcwrite;
endmodule