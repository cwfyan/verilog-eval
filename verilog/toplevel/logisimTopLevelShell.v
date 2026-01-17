/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : logisimTopLevelShell                                         **
 **                                                                          **
 *****************************************************************************/

module logisimTopLevelShell(  );

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [3:0] s_in;
   wire       s_out_and;
   wire       s_out_or;
   wire       s_out_xor;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** All signal adaptations are performed here                                  **
   *******************************************************************************/
   assign s_in[0] = 1'b0;
   assign s_in[1] = 1'b0;
   assign s_in[2] = 1'b0;
   assign s_in[3] = 1'b0;

   /*******************************************************************************
   ** The toplevel component is connected here                                   **
   *******************************************************************************/
   TopModule   CIRCUIT_0 (.in(s_in),
                          .out_and(s_out_and),
                          .out_or(s_out_or),
                          .out_xor(s_out_xor));
endmodule
