module switch(
	CLK_50M,
	rst_n,
	flag_complete,
	LCD_RS1,
	LCD_RW1,
	LCD_EN1,
	LCD_DATA1,
	Enable1,
	LCD_RS2,
	LCD_RW2,
	LCD_EN2,
	LCD_DATA2,
	Enable2,
	LCD_RS,
	LCD_RW,
	LCD_EN,
	LCD_DATA
);

input CLK_50M;
input rst_n;
input flag_complete;
input LCD_RS1;
input LCD_RW1;
input LCD_EN1;
input [7:0]LCD_DATA1;
input LCD_RS2;
input LCD_RW2;
input LCD_EN2;
input [7:0]LCD_DATA2;

output Enable1;
output Enable2;
output LCD_RS;
output LCD_RW;
output LCD_EN;
output [7:0]LCD_DATA;

reg LCD_RS;
reg LCD_RW;
reg LCD_EN;
reg [7:0]LCD_DATA;
reg Enable1;
reg Enable2;

always@(posedge CLK_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		LCD_RS<=LCD_RS1;
		LCD_RW<=LCD_RW1;
		LCD_EN<=LCD_EN1;
		LCD_DATA<=LCD_DATA1;
		Enable1<=1'b1;
		Enable2<=1'b0;
	end
	else
	begin
		if(flag_complete)
		begin
			Enable1<=1'b0;
			Enable2<=1'b1;			
			LCD_RS<=LCD_RS2;
			LCD_RW<=LCD_RW2;
			LCD_EN<=LCD_EN2;
			LCD_DATA<=LCD_DATA2;		
		end
		else
		begin
			LCD_RS<=LCD_RS1;
			LCD_RW<=LCD_RW1;
			LCD_EN<=LCD_EN1;
			LCD_DATA<=LCD_DATA1;
			Enable1<=1'b1;
			Enable2<=1'b0;
		end	
	end
end

endmodule
