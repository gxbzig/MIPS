module barrel (
input [31:0]in,
input [4:0]sh,
input [0:1] mod, // 1-rotate 0-left
//input rotate,left,
output [31:0] out
);


	wire [31:0] a;
	wire [31:0] y;
	wire [15:0]rb4;
	wire [31:0]b4;
	wire [7:0]rb3;
	wire [31:0]b3;
	wire [3:0]rb2;
	wire [31:0]b2;
	wire [1:0]rb1;
	wire [31:0]b1;
	wire rb0;


	genvar m;
		generate
		for (m=0; m < 32; m=m+1) begin : REVERSE_INPUT
			assign a[m] = (mod[0])?(in[31-m]):(in[m]);
		end
   endgenerate
	
	genvar c, d, e, f, g, h, i, j, k, l;
	
   generate
		for (k=0; k < 16; k=k+1) begin : ROTATE_B4
			assign rb4[k] = (mod[1])?(a[k]):(1'b0);
		end
   endgenerate

   generate
		for (l=0; l < 32; l=l+1) begin : B4
			if(l < 16)
				assign b4[l] = (sh[4])?(a[l+16]):(a[l]);
			else
				assign b4[l] = (sh[4])?(rb4[l-16]):(a[l]);
		end
   endgenerate
		
   generate
		for (d=0; d < 8; d=d+1) begin : ROTATE_B3
			assign rb3[d] = (mod[1])?(a[d]):(1'b0);
		end
   endgenerate

   generate
		for (c=0; c < 32; c=c+1) begin : B3
			if(c < 24)
				assign b3[c] = (sh[3])?(a[c+8]):(a[c]);
			else
				assign b3[c] = (sh[3])?(rb3[c-24]):(a[c]);
		end
   endgenerate
	
   generate
		for (e=0; e < 4; e=e+1) begin : ROTATE_B2
			assign rb2[e] = (mod[1])?(b3[e]):(1'b0);
		end
   endgenerate
	
   generate
		for (f=0; f < 32; f=f+1) begin : B2
			if(f < 28)
				assign b2[f] = (sh[2])?(b3[f+4]):(b3[f]);
			else
				assign b2[f] = (sh[2])?(rb2[f-28]):(b3[f]);
		end
   endgenerate
	
   generate
		for (g=0; g < 2; g=g+1) begin : ROTATE_B1
			assign rb1[g] = (mod[1])?(b2[g]):(1'b0);
		end
   endgenerate
	
   generate
		for (h=0; h < 32; h=h+1) begin : B1
			if(h < 30)
				assign b1[h] = (sh[1])?(b2[h+2]):(b2[h]);
			else
				assign b1[h] = (sh[1])?(rb1[h-30]):(b2[h]);
		end
   endgenerate
	
	assign rb0 = (mod[1])?(b1[0]):(1'b0);
	
	 generate
		for (j=0; j < 32; j=j+1) begin : B0
			if(j < 31)
				assign y[j] = (sh[0])?(b1[j+1]):(b1[j]);
			else
				assign y[j] = (sh[0])?(rb0):(b1[j]);
		end
   endgenerate
	
	
	genvar n;
	generate
		for (n=0; n < 32; n=n+1) begin : REVERSE_OUTPUT
			assign out[n] = (mod[0])?(y[31-n]):(y[n]);
		end
   endgenerate

endmodule
