    module counter (input clk,      // Declare input port for the clock to allow counter to count up  
                      input rstn,              // Declare input port for the reset to allow the counter to be reset to 0 when required  
                      output reg[3:0] out);    // Declare 4-bit output port to get the counter values  
      
     // This always block will be triggered at the rising edge of clk (0->1)  
      // Once inside this block, it checks if the reset is 0, then change out to zero   
      // If reset is 1, then the design should be allowed to count up, so increment the counter   
      
      always @ (posedge clk) begin  
        if (! rstn)  
          out <= 0;  
        else  
          out <= out + 1;  
      end  
    endmodule  
    
    

//	module tb_counter;  
//      reg clk;                     // Declare an internal TB variable called clk to drive clock to the design  
//      reg rstn;                    // Declare an internal TB variable called rstn to drive active low reset to design  
//      wire [3:0] out;              // Declare a wire to connect to design output  
//      
//      // Instantiate counter design and connect with Testbench variables  
//      counter   c0 ( .clk (clk),  
//                     .rstn (rstn),  
//                     .out (out));  
//      
//      // Generate a clock that should be driven to design  
//      // This clock will flip its value every 5ns -> time period = 10ns -> freq = 100 MHz  
//       
//     always #5 clk = ~clk;  
//      
//      // This initial block forms the stimulus of the testbench  
//      initial begin  
//        // Initialize testbench variables to 0 at start of simulation  
//        clk <= 0;  
//        rstn <= 0;  
//      
//        // Drive rest of the stimulus, reset is asserted in between  
//        #20   rstn <= 1;  
//        #80   rstn <= 0;  
//        #50   rstn <= 1;  
//      
//        // Finish the stimulus after 200ns  
//        #20 $finish;  
//      end  
//    endmodule  