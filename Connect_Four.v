/*module Connect_Four (
    input clk,  // Clock input
    input reset,  // Reset input
    input [6:0] switch, // 7 switches for column selection
    output reg hsync, vsync,  // VGA sync signals
    output reg [2:0] red, green, blue  // VGA color signals
);

    parameter HORIZ_SYNC_PULSE = 96;
    parameter HORIZ_BACK_PORCH = 48;
    parameter HORIZ_DISP_TIME  = 640;
    parameter HORIZ_FRONT_PORCH = 16;
    parameter VERT_SYNC_PULSE = 2;
    parameter VERT_BACK_PORCH = 33;
    parameter VERT_DISP_TIME  = 480;
    parameter VERT_FRONT_PORCH = 10;
   
    parameter PIXELS_PER_COLUMN = 228;  // Width of each cell in pixels
    parameter PIXELS_PER_ROW = 150;     // Height of each cell in pixels

    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    wire [6:0] debounced_switches;  // Debounced switch signals

    // Instantiate debouncer for each switch
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : switch_debouncer
            Debouncer db(.clk(clk), .noisy_switch(switch[i]), .debounced_switch(debounced_switches[i]));
        end
    endgenerate
	 
	 wire clk_25Hz;

	 clk_divider clk_div_inst (
		.clk_in(clk),
		.clk_out(clk_25Hz)
	 );

    // Game board representation
    reg [1:0] game_board [0:6][0:5];  // 7 columns x 6 rows
    reg [1:0] current_player = 2'b01;  // Start with Player 1
    reg [6:0] last_switch_state = 7'b0;
	 //reg [1:0] flat_game_board[0:41];

    integer row, col, j;
    reg checker_placed;
	 
	 
    // Handle player moves, game board update, and reset logic
    always @(posedge clk_25Hz) begin
        checker_placed = 0;  // Reset the flag each clock cycle
        if (reset) begin
            // Reset logic for the game board
            for (col = 0; col < 7; col = col + 1) begin
                for (row = 0; row < 6; row = row + 1) begin
                    game_board[col][row] <= 2'b00;
                end
            end
            current_player <= 2'b01;  // Reset to Player 1
            last_switch_state <= 7'b0;
				//game_over <= 0;
        end else begin
            // Normal game operation
            for (j = 0; j < 7; j = j + 1) begin
                if (debounced_switches[j] && !last_switch_state[j]) begin
                    // Place checker in the selected column
                    for (row = 5; row >= 0 && !checker_placed; row = row - 1) begin
                        if (game_board[j][row] == 2'b00) begin
                            game_board[j][row] <= current_player;
                            checker_placed = 1;  // Set the flag to indicate a checker has been placed
                        end
                    end

                    // Switch player
                    current_player <= (current_player == 2'b01) ? 2'b10 : 2'b01;
                end
            end

            last_switch_state <= debounced_switches;
				// After each player's move, check if the game is over
            /*if (checker_placed) begin
                if (win_condition.game_over) begin
                    // Game is over, take appropriate action (e.g., display winner)
                    // Set game_over flag as needed
                    //game_over <= 1;
                end
            end
        end
    end

    integer board_x, board_y;

    // VGA signal generation
    always @(posedge clk_25Hz) begin
        // Horizontal timing
        if (h_count < (HORIZ_SYNC_PULSE + HORIZ_BACK_PORCH + HORIZ_DISP_TIME + HORIZ_FRONT_PORCH - 1))
            h_count <= h_count + 1;
        else begin
            h_count <= 0;

            // Vertical timing
            if (v_count < (VERT_SYNC_PULSE + VERT_BACK_PORCH + VERT_DISP_TIME + VERT_FRONT_PORCH - 1))
                v_count <= v_count + 1;
            else
                v_count <= 0;
        end

        // Generate sync signals
        hsync <= (h_count < HORIZ_SYNC_PULSE) ? 1'b0 : 1'b1;
        vsync <= (v_count < VERT_SYNC_PULSE) ? 1'b0 : 1'b1;

        // Display logic
                // Display logic
        if (h_count >= HORIZ_SYNC_PULSE + HORIZ_BACK_PORCH &&
            h_count < HORIZ_SYNC_PULSE + HORIZ_BACK_PORCH + HORIZ_DISP_TIME &&
            v_count >= VERT_SYNC_PULSE + VERT_BACK_PORCH &&
            v_count < VERT_SYNC_PULSE + VERT_BACK_PORCH + VERT_DISP_TIME) begin

            // Calculate board_x and board_y based on current pixel position
            board_x = (h_count - (HORIZ_SYNC_PULSE + HORIZ_BACK_PORCH)) / PIXELS_PER_COLUMN;
            board_y = (v_count - (VERT_SYNC_PULSE + VERT_BACK_PORCH)) / PIXELS_PER_ROW;

            // Display the game board cells and checkers
            if (board_x < 7 && board_y < 6) begin
                case (game_board[board_x][board_y])
                    2'b01: {red, green, blue} <= 3'b100; // Red for Player 1
                    2'b10: {red, green, blue} <= 3'b001; // Blue for Player 2
                    default: {red, green, blue} <= 3'b111; // White for empty cell
                endcase
            end else begin
                {red, green, blue} <= 3'b000; // Black outside the game board
            end
        end else begin
            // Outside the display area
            {red, green, blue} <= 3'b000; // Black or background color
        end
    end
endmodule */

module Connect_Four (
	input clock,  // Clock input
	input resetn,  // Reset input
	input button1,
	input button0,
	input [7:0] player_input, // 7 switches for column selection
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

    // Instantiate the game logic
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

    // Instantiate the VGA adapter
    vga_adapter vga_output (
        .resetn(resetn),
        .clock(clock),
        // ... set parameters for VGA adapter
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

