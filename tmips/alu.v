/*
 * From D. M. Harris and S. L. Harris, "Digital Design and Computer Architecture"
 */
`timescale 1ns / 1ps
module alu(
    input [31:0] srca,
    input [31:0] srcb,
    input [2:0] alucontrol,
    output reg [31:0] aluout,
    output reg zero
    );

   always @ (*)
     begin
	case (alucontrol)
	  3'b000: aluout <= srca & srcb;
	  3'b001: aluout <= srca | srcb;
	  3'b010: aluout <= srca + srcb;
	  3'b110: aluout <= srca - srcb;
	  3'b111: aluout <= (srca-srcb)>>31;
	endcase
	zero <= (srca == srcb) ? 1 : 0;
     end

endmodule

module alutest;

   reg [31:0] opa, opb;
   reg [2:0]  aluc;
   wire [31:0] res;
   wire        zero;

   alu alu1(opa, opb, aluc, res, zero);

   initial begin
      $dumpfile("alutest.vcd");
      $dumpvars(0, alutest);
      aluc = 0; #1
      opa = 8; opb = 1;   #1
      aluc = 1; #1
      aluc = 2; #1
      aluc = 6; #1
      aluc = 7; #1
      opa = -8; opb = -1;
      aluc = 0; #1
      aluc = 1; #1
      aluc = 2; #1
      aluc = 6; #1
      aluc = 7; #1
      $finish;
   end


endmodule // alutest
