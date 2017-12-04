/*
 * From D. M. Harris and S. L. Harris, "Digital Design and Computer Architecture"
 */
`timescale 1ns / 1ps
module maindec(
    input [5:0] op,
    output memtoreg,
    output memwrite,
    output branch,
    output alusrc,
    output regdst,
    output [1:0] immtype,
    output regwrite,
    output jump,
    output [1:0] aluop
    );

   reg [10:0] 	 controls;

   assign { regwrite, immtype, regdst, alusrc, branch, memwrite,
	    memtoreg, jump, aluop } = controls;

   always @ (*)
     case (op)
       6'b000000: controls <= 11'b10010000010; //Rtype
       6'b100011: controls <= 11'b10001001000; //LW
       6'b101011: controls <= 11'b00001010000; //SW
       6'b000100: controls <= 11'b00000100001; //BEQ
       6'b001000: controls <= 11'b10001000000; //ADDI
       6'b001111: controls <= 11'b11001000011; //LUI
       6'b001101: controls <= 11'b10101000011; //ORI
       6'b000010: controls <= 11'b00000000100; //J
       default:   controls <= 11'bxxxxxxxxxxx; //???
     endcase

endmodule

module aludec(
    input [5:0] funct,
    input [1:0] aluop,
    output reg [2:0] alucontrol
    );

   always @ (*)
     case (aluop)
       2'b00: alucontrol <= 3'b010; // addition
       2'b01: alucontrol <= 3'b110; // subtraction
       2'b11: alucontrol <= 3'b001; // or
       default: case (funct) // Rtype (aluop is 10)
		  6'b100000: alucontrol <= 3'b010; //ADD
		  6'b100010: alucontrol <= 3'b110; //SUB
		  6'b100100: alucontrol <= 3'b000; //AND
		  6'b100101: alucontrol <= 3'b001; //OR
		  6'b101010: alucontrol <= 3'b111; //SLT
		  default:   alucontrol <= 3'bxxx; //???
		endcase
     endcase
endmodule

module controller(
    input [5:0] op,
    input [5:0] funct,
    input zero,
    output memtoreg,
    output memwrite,
    output pcsrc,
    output alusrc,
    output regdst,
    output [1:0] immtype,
    output regwrite,
    output jump,
    output [2:0] alucontrol
    );

   wire [1:0] 	 aluop;
   wire 	 branch;

   maindec md (op, memtoreg, memwrite, branch, alusrc,
	       regdst, immtype, regwrite, jump, aluop);
   aludec ad (funct, aluop, alucontrol);

   assign pcsrc = branch & zero;
endmodule

module testcont;
   reg [5:0] op;
   reg [5:0] funct;
   reg 	     zero;
   wire      memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump;
   wire [1:0] immtype;
   wire [2:0] alucontrol;

   controller ctl(op, funct, zero, memtoreg, memwrite, pcsrc,
		  alusrc, regdst, immtype, regwrite, jump, alucontrol);

   initial begin
      $dumpfile("testcont.vcd");
      $dumpvars(0, testcont);
      zero = 0; op = 0; funct = 6'b101010; #1
      op = 'h2b; #1
      op = 'h04; #1
      op = 'h08; #1
      op = 'h02; #1
      $finish;
   end
endmodule // testcont
