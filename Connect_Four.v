module Connect_Four (
	input clock,  // Clock input
	input resetn,  // Reset input
	input button1,
	input button0,
	input [7:0] player_input, // 8 switches for column selection
	input KEY0,
	output reg [2:0] red, green, blue, 
	// VGA outputs
	output [9:0]VGA_R,
	output [9:0]VGA_G,
	output [9:0]VGA_B,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK,
	output VGA_SYNC,
	output VGA_CLK
	);

	wire [2:0] colour;
	wire [9:0] x;
	wire [8:0] y;
	wire plot;

	// Instantiating the game logic
	game_logic game_logic (
		.clock(clock),
		.resetn(resetn),
		.button1(button1),
		.button0(button0),
		.player_input(player_input),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(plot)
	);

	// Instantiating the VGA adapter
	vga_adapter vga_output (
		.resetn(resetn),
		.clock(clock),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(plot),
		// VGA signals
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK), 
		.VGA_SYNC(VGA_SYNC), 
		.VGA_CLK(VGA_CLK)
	);

endmodule

