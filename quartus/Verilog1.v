//    module counter (input clk,      // Declare input port for the clock to allow counter to count up  
//                      input rstn,              // Declare input port for the reset to allow the counter to be reset to 0 when required  
//                      output reg[7:0] out);    // Declare 4-bit output port to get the counter values  
//      //                output reg[7:0] out);    // Declare 4-bit output port to get the counter values  
//     // This always block will be triggered at the rising edge of clk (0->1)  
//      // Once inside this block, it checks if the reset is 0, then change out to zero   
//      // If reset is 1, then the design should be allowed to count up, so increment the counter   
//      
//      always @ (posedge clk) begin  
//        if (! rstn)  
//          out <= 0;  
//        else  s
//          out <= out + 1;  
//      end  
//    endmodule  
    
    module combo (input a, b, c, d, output  o);  
	assign o = ~((a & b) | c ^ d);  
	endmodule
    
//    module all_gates (output x1, y1, z1, x2, y2, z2 , input a, b, c, d);  
//      and (x1, a, b, c, d);   // x1 is the output, a, b, c, d are inputs  
//      or  (y1, a, b, c, d);  // y1 is the output, a, b, c, d are inputs  
//      xor (z1, a, b, c, d);   // z1 is the output, a, b, c, d are inputs  
//      nand (x2, a, b, c, d); // x2 is the output, a, b, c, d are inputs  
//      nor (y2, a, b, c, d); // y2 is the output, a, b, c, d are inputs   
//      xnor (z2, a, b, c, d); // z2 is the output, a, b, c, d are inputs  
//    endmodule  
    
    module all_gates (output x1, y1, z1, x2, y2, z2 , input [3:0] a);  
      and (x1, a[0],a[1],a[2],a[3]);   // x1 is the output, a, b, c, d are inputs  
      or  (y1, a[1],a[2],a[3]);  // y1 is the output, a, b, c, d are inputs  
      xor (z1,a[1],a[2],a[3]);   // z1 is the output, a, b, c, d are inputs  
      nand (x2,a[1],a[2],a[3]); // x2 is the output, a, b, c, d are inputs  
      nor (y2,a[1],a[2],a[3]); // y2 is the output, a, b, c, d are inputs   
      xnor (z2,a[1],a[2],a[3]); // z2 is the output, a, b, c, d are inputs  
    endmodule 