module mips(input logic clk, reset, output logic [31:0] pc,
            output logic memwrite,
            output logic [31:0] adr, writedata,
            input logic [31:0] readdata);
            
  logic alusrcA, alusrcB, regdst, regwrite, jump, pcsrc, zero, memtoreg, pcen, iord, pcwrite, irwrite;
  logic [2:0] alucontrol;
  logic [31:0] instr;
  
  controller c(instr[31:26], instr[5:0], zero, clk, reset, memtoreg, memwrite,
    pcsrc, pcen, alusrcA, alusrcB, regdst, regwrite, iord, jump, pcwrite, irwrite, alucontrol);
  
  datapath dp(clk, reset, memtoreg, pcsrc, pcen, alusrcA, regdst, alusrcB, regwrite,
    jump, iord, irwrite, alucontrol, zero, pc, adr, writedata, instr, readdata);

endmodule