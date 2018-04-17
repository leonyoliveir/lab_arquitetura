module datapath(input logic clk, reset,
                input logic memtoreg, pcsrc, pcen,
                input logic alusrcA, regdst,
                input logic [1:0] alusrcB,
                input logic regwrite, jump, iord, irwrite, 
                input logic [2:0] alucontrol,
                output logic zero,
                output logic [31:0] pc,
                output logic [31:0] adr, writedata,
                output logic [31:0] instr,
                input logic [31:0] readdata);
  logic [4:0] writereg;
  logic [31:0] pcnext;
  logic [31:0] signimm, signimmsh;
  logic [31:0] srca, srcb, aout, bout, aread;
  logic [31:0] result, wdata;
  logic [31:0] aluresult, aluout;
  logic [31:0] data;

  // next PC logic
  reg1 #(32) pcregenable(clk, reset, pcen, pcnext, pc);
  mux2 #(32) pcadrmux(pc, aluout, iord, adr);
  reg1 #(32) instuctreg(clk, reset, irwrite, readdata, instr);
  reg2 #(32) datareg(clk, reset, readdata, data);
  sl2 immsh(signimm, signimmsh);
  mux2 #(32) pcmux(aluresult, aluout, pcsrc, pcnext);
  
  // register file logic
  regfile rf(clk, regwrite, instr[25:21], instr[20:16], writereg, wdata, aread, writedata);
  mux2 #(5) wrmux(instr[20:16], instr[15:11], regdst, writereg);
  reg2 #(32) areg(clk, reset, aread, aout);
  reg2 #(32) breg(clik, reset, writedata, bout);
  mux2 #(32) wrdata(aluout, data, memtoreg, wdata); 
  signext se(instr[15:0], signimm);

  // ALU logic
  
  mux2 #(32) srcamux(pc, aout, alusrcA, srca);
  mux4 #(32) srcbmux(bout, 32'b100, signimm, signimmsh, alusrcB, srcb);
  alu32 alu(srca, srcb, alucontrol, aluresult, zero);
  reg2 #(32) alureg(clk, reset, aluresult, aluout);
endmodule
