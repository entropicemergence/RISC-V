    module all_gates_a (a, b, out,car); 
		input [7:0]a;
		input [7:0]b;
		input car;
		output [7:0]out;
		
		//output reg y;
		wire [16:0]bus1;
		wire [7:0]carw;
		
		
		// while (iter < 4) begin
		// 	and(wire[iter],a[iter],b[iter])
		// 	iter = iter + 1;
		// end
		
//		integer i;
//		initial begin
//			y=a[0]&b[0];
//			for (i=0; i < 5 ; i=i+1)begin
//				//assign out[i] = a[1] & b[3];
//				//out[i] = a[1] & b[3];
//				//and(bus1[i],a[i],b[i]);
//				//y = y&b[i];
//			end
//		end

		assign bus1[0] = a[0] & b[0];
		assign bus1[1] = a[1] & b[1];
		assign bus1[2] = a[2] & b[2];
		assign bus1[3] = a[3] & b[3];
		assign bus1[4] = a[4] & b[4];
		assign bus1[5] = a[5] & b[5];
		assign bus1[6] = a[6] & b[6];
		assign bus1[7] = a[7] & b[7];
		assign bus1[8] = a[0] | b[0];
		assign bus1[9] = a[1] | b[1];
		assign bus1[10] = a[2] | b[2];
		assign bus1[11] = a[3] | b[3];
		assign bus1[12] = a[4] | b[4];
		assign bus1[13] = a[5] | b[5];
		assign bus1[14] = a[6] | b[6];
		assign bus1[15] = a[7] | b[7];
		assign bus1[16] = car;
		
//		assign carw[0]=bus1[16];
//		assign carw[1]=(bus1[16]&bus1[8])|bus1[0];
//		assign carw[2]=(bus1[16]&bus1[8]&bus1[9])|(bus1[0]&bus1[9])|bus1[1];
//		assign carw[3]=(bus1[16]&bus1[8]&bus1[9]&bus1[10])|(bus1[0]&bus1[9]&bus1[10])|(bus1[1]&bus1[10])|bus1[2];
//		assign carw[4]=(bus1[16]&bus1[8]&bus1[9]&bus1[10]&bus1[11])|(bus1[0]&bus1[9]&bus1[10]&bus1[11])|(bus1[1]&bus1[10]&bus1[11])|(bus1[2]&bus1[11])|(bus1[3]);
//		assign carw[5]=(bus1[16]&bus1[8]&bus1[9]&bus1[10]&bus1[11]&bus1[12])|(bus1[0]&bus1[9]&bus1[10]&bus1[11]&bus1[12])|(bus1[1]&bus1[10]&bus1[11]&bus1[12])|
//		(bus1[2]&bus1[11]&bus1[12])|(bus1[3]&bus1[12])|(bus1[4]);
//		assign carw[6]=(bus1[16]&bus1[8]&bus1[9]&bus1[10]&bus1[11]&bus1[12]&bus1[13])|(bus1[0]&bus1[9]&bus1[10]&bus1[11]&bus1[12]&bus1[13])|
//		(bus1[1]&bus1[10]&bus1[11]&bus1[12]&bus1[13])|(bus1[2]&bus1[11]&bus1[12]&bus1[13])|(bus1[3]&bus1[12]&bus1[13])|(bus1[4]&bus1[13])|(bus1[5]);
//		assign carw[7]=(bus1[16]&bus1[8]&bus1[9]&bus1[10]&bus1[11]&bus1[12]&bus1[13]&bus1[14])|(bus1[0]&bus1[9]&bus1[10]&bus1[11]&bus1[12]&bus1[13]&bus1[14])|
//		(bus1[1]&bus1[10]&bus1[11]&bus1[12]&bus1[13]&bus1[14])|(bus1[2]&bus1[11]&bus1[12]&bus1[13]&bus1[14])|(bus1[3]&bus1[12]&bus1[13]&bus1[14])|(bus1[4]&bus1[13]&bus1[14])|(bus1[5]&bus1[14])|(bus1[6]);

		
		
		assign carw[0]=bus1[16];
		
		wire a1;
		and (a1,bus1[16],bus1[8]);
		assign carw[1]=a1|bus1[0];
		
		wire [1:0]a2;
		and (a2[0],bus1[16],bus1[8],bus1[9]);
		and (a2[1],bus1[0],bus1[9]);
		assign carw[2]=a2[0]|(a2[1])|bus1[1];
		
		wire [2:0]a3;
		and (a3[0],bus1[16],bus1[8],bus1[9],bus1[10]);
		and (a3[1],bus1[0],bus1[9],bus1[10]);
		and (a3[2],bus1[1],bus1[10]);
		assign carw[3]=(a3[0])|(a3[1])|(a3[2])|bus1[2];
		
		wire [3:0]a4;
		and (a4[0],bus1[16],bus1[8],bus1[9],bus1[10],bus1[11]);
		and (a4[1],bus1[0],bus1[9],bus1[10],bus1[11]);
		and (a4[2],bus1[1],bus1[10],bus1[11]);
		and (a4[3],bus1[2],bus1[11]);
		assign carw[4]=(a4[0])|(a4[1])|(a4[2])|(a4[3])|(bus1[3]);
		
		
		wire [4:0]a5;
		and (a5[0],bus1[16],bus1[8],bus1[9],bus1[10],bus1[11],bus1[12]);
		and (a5[1],bus1[0],bus1[9],bus1[10],bus1[11],bus1[12]);
		and (a5[2],bus1[1],bus1[10],bus1[11],bus1[12]);
		and (a5[3],bus1[2],bus1[11],bus1[12]);
		and (a5[4],bus1[3],bus1[12]);
		assign carw[5]=(a5[0])|(a5[1])|(a5[2])|(a5[3])|(a5[4])|(bus1[4]);
		
		
		wire [5:0]a6;
		and (a6[0],bus1[16],bus1[8],bus1[9],bus1[10],bus1[11],bus1[12],bus1[13]);
		and (a6[1],bus1[0],bus1[9],bus1[10],bus1[11],bus1[12],bus1[13]);
		and (a6[2],bus1[1],bus1[10],bus1[11],bus1[12],bus1[13]);
		and (a6[3],bus1[2],bus1[11],bus1[12],bus1[13]);
		and (a6[4],bus1[3],bus1[12],bus1[13]);
		and (a6[5],bus1[4],bus1[13]);		
		assign carw[6]=(a6[0])|(a6[1])|(a6[2])|(a6[3])|(a6[4])|(a6[5])|(bus1[5]);
		
		wire [6:0]a7;
		and (a7[0],bus1[16],bus1[8],bus1[9],bus1[10],bus1[11],bus1[12],bus1[13],bus1[14]);
		and (a7[1],bus1[0],bus1[9],bus1[10],bus1[11],bus1[12],bus1[13],bus1[14]);
		and (a7[2],bus1[1],bus1[10],bus1[11],bus1[12],bus1[13],bus1[14]);
		and (a7[3],bus1[2],bus1[11],bus1[12],bus1[13],bus1[14]);
		and (a7[4],bus1[3],bus1[12],bus1[13],bus1[14]);
		and (a7[5],bus1[4],bus1[13],bus1[14]);
		and (a7[6],bus1[5],bus1[14]);
		assign carw[7]=(a7[0])|(a7[1])|(a7[2])|(a7[3])|(a7[4])|(a7[5])|(a7[6])|(bus1[6]);
		
		
		assign out[0]=(~bus1[0]&bus1[8])^carw[0];
		assign out[1]=(~bus1[1]&bus1[9])^carw[1];
		assign out[2]=(~bus1[2]&bus1[10])^carw[2];
		assign out[3]=(~bus1[3]&bus1[11])^carw[3];
		assign out[4]=(~bus1[4]&bus1[12])^carw[4];
		assign out[5]=(~bus1[5]&bus1[13])^carw[5];
		assign out[6]=(~bus1[6]&bus1[14])^carw[6];
		assign out[7]=(~bus1[7]&bus1[15])^carw[7];
		
		
//		assign out[0]=(a[0]^b[1]);
//		assign out[0]=(a[0]^b[0])^car;
//		assign out[1]=(a[1]^b[1])^((a[0]&b[0])|(car&(a[0]|b[0])));
//		assign out[2]=(a[2]^b[2])^((a[1]&b[1])|((a[0]&b[0])&(a[1]|b[1]))|(car&(a[0]|b[0])&(a[1]|b[1])));
//		assign out[3]=(a[3]^b[3])^((a[2]&b[2])|((a[1]&b[1])&(a[2]|b[2]))|((a[0]&b[0])&(a[1]|b[1])&(a[2]|b[2]))|(car&(a[0]|b[0])&(a[1]|b[1])&&(a[2]|b[2])));
		
		
		
		
		//assign out[1]=bus1[3]^bus1[8]^bus1[6]^bus1[5];
		



		//assign out[0]=bus1[0]&bus1[1]&bus1[2]&bus1[3]&bus1[4]&(!a[0]);
		
//		output x1, y1, z1, x2, y2, z2;
//		and (x1, a[0],a[1],a[2],a[3]);   // x1 is the output, a, b, c, d are inputs  
//		or  (y1, a[1],a[2],a[3]);  // y1 is the output, a, b, c, d are inputs  
//		xor (z1,a[1],a[2],a[3]);   // z1 is the output, a, b, c, d are inputs  
//		nand (x2,a[1],a[2],a[3]); // x2 is the output, a, b, c, d are inputs  
//		nor (y2,a[1],a[2],a[3]); // y2 is the output, a, b, c, d are inputs   
//		xnor (z2,a[1],a[2],a[3]); // z2 is the output, a, b, c, d are inputs  
      
    endmodule 