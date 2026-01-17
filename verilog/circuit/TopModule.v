/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : TopModule                                                    **
 **                                                                          **
 *****************************************************************************/

module TopModule( in,
                  out_and,
                  out_or,
                  out_xor );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [3:0] in;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output out_and;
   output out_or;
   output out_xor;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [3:0] s_logisimBus4;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet14;
   wire       s_logisimNet15;
   wire       s_logisimNet2;
   wire       s_logisimNet3;
   wire       s_logisimNet5;
   wire       s_logisimNet6;
   wire       s_logisimNet7;
   wire       s_logisimNet8;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus4[3:0] = in;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign out_and = s_logisimNet10;
   assign out_or  = s_logisimNet11;
   assign out_xor = s_logisimNet12;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE_4_INPUTS #(.BubblesMask(4'h0))
      and_gate (.input1(s_logisimBus4[0]),
                .input2(s_logisimBus4[1]),
                .input3(s_logisimBus4[2]),
                .input4(s_logisimBus4[3]),
                .result(s_logisimNet10));

   OR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      or_gate (.input1(s_logisimBus4[0]),
               .input2(s_logisimBus4[1]),
               .input3(s_logisimBus4[2]),
               .input4(s_logisimBus4[3]),
               .result(s_logisimNet11));

   XOR_GATE_4_INPUTS #(.BubblesMask(4'h0))
      xor_gate (.input1(s_logisimBus4[0]),
                .input2(s_logisimBus4[1]),
                .input3(s_logisimBus4[2]),
                .input4(s_logisimBus4[3]),
                .result(s_logisimNet12));


endmodule
