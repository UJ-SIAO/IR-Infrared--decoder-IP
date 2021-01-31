module Lab3(
	CLK_50M,
	rst_n,
	IRDA_RX,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_DATA,
	LCD_ON,
	flag_complete1,
	LCD_BLON
);

input CLK_50M;
input rst_n;
input IRDA_RX;
output LCD_RS;
output LCD_RW;
output LCD_EN;
output [7:0]LCD_DATA;
output LCD_ON;
output flag_complete1;
output LCD_BLON;

wire LCD_RS1;
wire LCD_RW1;
wire LCD_EN1;
wire [7:0]LCD_DATA1;
wire Enable1; 
wire LCD_RS2;
wire LCD_RW2;
wire LCD_EN2;
wire [7:0]LCD_DATA2;
wire Enable2; 
wire flag_complete;
wire LCD_ON;
wire [31:0]DATA;

assign LCD_ON=1'b1;
assign LCD_BLON=1'b0;

init	ini(
	.CLK_50M(CLK_50M),
	.LCD_DATA(LCD_DATA1),
	.LCD_EN(LCD_EN1),
	.LCD_RW(LCD_RW1),
	.LCD_RS(LCD_RS1),
	.rst_n(rst_n),
	.Enable(Enable1),
	.flag_complete(flag_complete)
);

assign flag_complete1=~flag_complete;

Show Show1(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.DATA(DATA),
	.LCD_RS(LCD_RS2),
	.LCD_RW(LCD_RW2),
	.LCD_EN(LCD_EN2),
	.LCD_DATA(LCD_DATA2),
	.Enable(Enable2)		
);

IR IR1(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.IRDA_RX(IRDA_RX),
	.DATA(DATA)	
);


switch switch1(
	.CLK_50M(CLK_50M),
	.rst_n(rst_n),
	.flag_complete(flag_complete),
	.LCD_RS1(LCD_RS1),
	.LCD_RW1(LCD_RW1),
	.LCD_EN1(LCD_EN1),
	.LCD_DATA1(LCD_DATA1),
	.Enable1(Enable1),
	.LCD_RS2(LCD_RS2),
	.LCD_RW2(LCD_RW2),
	.LCD_EN2(LCD_EN2),
	.LCD_DATA2(LCD_DATA2),
	.Enable2(Enable2),
	.LCD_RS(LCD_RS),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_DATA(LCD_DATA)
);

endmodule
