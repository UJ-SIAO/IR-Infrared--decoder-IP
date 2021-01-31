module select(
	CLK_50M,
	rst_n,
	select_in,
	select_out
);

input CLK_50M;
input rst_n;
input [3:0]select_in;
output [7:0]select_out;

reg [7:0]select_out;
parameter 	LCD_0 = 8'b00110000;
parameter	LCD_1 = 8'b00110001;
parameter	LCD_2 = 8'b00110010;
parameter	LCD_3 = 8'b00110011;
parameter	LCD_4 = 8'b00110100;
parameter	LCD_5 = 8'b00110101;
parameter	LCD_6 = 8'b00110110;
parameter	LCD_7 = 8'b00110111;
parameter	LCD_8 = 8'b00111000;
parameter	LCD_9 = 8'b00111001;
parameter	LCD_E = 8'b01000101;
always@(*)
begin
	if(!rst_n)
		select_out<=8'b00110000;
	else
	begin
		case(select_in)
			0: select_out<=8'b00110000;
			1: select_out<=8'b00110001;
			2: select_out<=8'b00110010;
			3: select_out<=8'b00110011;
			4: select_out<=8'b00110100;
			5: select_out<=8'b00110101;
			6: select_out<=8'b00110110;
			7: select_out<=8'b00110111;
			8: select_out<=8'b00111000;
			9: select_out<=8'b00111001;
			default:select_out<=8'b01000101;
		endcase
	end
end

endmodule
