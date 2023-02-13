    module all_gates_a (a, b, out, x1, y1, z1, x2, y2, z2); 
		input [7:0]a;
		input [7:0]b;
		output [7:0]out;
		
		wire [15:0]bus1;
		
		and(
		
		
		
		
		
		
		
		output x1, y1, z1, x2, y2, z2;
		and (x1, a[0],a[1],a[2],a[3]);   // x1 is the output, a, b, c, d are inputs  
		or  (y1, a[1],a[2],a[3]);  // y1 is the output, a, b, c, d are inputs  
		xor (z1,a[1],a[2],a[3]);   // z1 is the output, a, b, c, d are inputs  
		nand (x2,a[1],a[2],a[3]); // x2 is the output, a, b, c, d are inputs  
		nor (y2,a[1],a[2],a[3]); // y2 is the output, a, b, c, d are inputs   
		xnor (z2,a[1],a[2],a[3]); // z2 is the output, a, b, c, d are inputs  
      
    endmodule 