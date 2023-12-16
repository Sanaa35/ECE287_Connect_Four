module game_logic(
    input clock,
    input resetn,
	 input button1,
	 input button0,
	 input [7:0]player_input,
    output reg [2:0] colour,
    output reg [9:0] x,
    output reg [8:0] y,
    output reg plot
);

	reg win_flag; // Flag to indicate if a player has won
   integer row, col, tally, dir_x, dir_y, jelly; //jelly mkakes no sense in naming, I just needed one bright light in my life
	 
	reg [26:0] counter;
	reg done;

	reg [1:0] game_board[7:0][5:0];
	integer i,j;
	integer count[7:0];
	initial begin
		for (i = 0; i < 8; i = i + 1) begin
			count[i] = 5;
		end
	end
	reg turn;
    // Constants for the grid
    parameter GRID_LINE_WIDTH = 4;
    parameter CELL_WIDTH = 40;
    parameter CELL_HEIGHT = 40;
    reg GRID_COLOR = 3'b001; // Blue
	 
	 wire [9:0] debounced_input;
	debouncer debounce_0(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[0]),
				.debounced_signal(debounced_input[0])
		);
		debouncer debounce_1(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[1]),
				.debounced_signal(debounced_input[1])
		);
		debouncer debounce_2(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[2]),
				.debounced_signal(debounced_input[2])
		);
		debouncer debounce_3(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[3]),
				.debounced_signal(debounced_input[3])
		);
		debouncer debounce_4(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[4]),
				.debounced_signal(debounced_input[4])
		);
		debouncer debounce_5(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[5]),
				.debounced_signal(debounced_input[5])
		);
		debouncer debounce_6(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[6]),
				.debounced_signal(debounced_input[6])
		);
		debouncer debounce_7(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(player_input[7]),
				.debounced_signal(debounced_input[7])
		);
		debouncer debounce_8(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(button1),
				.debounced_signal(debounced_input[8])
		);
		debouncer debounce_9(
				.clk(clock),
				.resetn(resetn),
				.noisy_signal(button0),
				.debounced_signal(debounced_input[9])
		);
		
    // Testing grid display
    always @(posedge clock) begin
        if (!resetn) begin
            // Reset logic
				done <= 0;
				counter <= 0;
            x <= 0;
            y <= 0;
				win_flag <= 0;
				turn <= 0;
            colour <= 3'b000; // Black
				GRID_COLOR <= 3'b001;
            plot <= 1'b0;
				for (i = 0; i < 8; i = i + 1) begin
                // Start from the bottom
					 count[i] <= 5;
                for (j = 0; j < 6; j = j + 1) begin
                    game_board[i][j] <= 2'b00;
                end
            end
        end else begin
			// Checker placement logic
            for (i = 0; i < 8; i = i + 1) begin
                if (debounced_input[i] && count[i] >= 0) begin
                    if ((debounced_input[8] && turn % 2 == 1) ||
                        (debounced_input[9] && turn % 2 == 0)) begin
                        // Place the checker for the appropriate player
                        game_board[i][count[i]] <= (turn % 2 == 0) ? 2'b01 : 2'b10;
                       
                        // Decrement count[i] for the next available position
                        count[i] <= count[i] - 1;
                        turn <= turn + 1;
                    end
                end
            end
				
				tally = 0;
				
				//Check for win condition
				for (col = 0; col < 8; col = col + 1) begin
					for (row = 0; row < 6; row = row + 1) begin
						if (game_board[col][row] == 2'b01) begin
							tally = 1; // The first checker
							//Upwards 4
							if (row < 3) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col][row + jelly] == 2'b01) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//Downward 4
							if (row > 2) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col][row - jelly] == 2'b01) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//diagonally up
							if (row < 3 && col < 5) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col + jelly][row + jelly] == 2'b01) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//diagonally down
							if (row > 2 && col < 5) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col + jelly][row - jelly] == 2'b01) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//4 in a row
							if (col < 5) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col + jelly][row] == 2'b01) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
						end else if (game_board[col][row] == 2'b10) begin
							tally = 1; // The first checker.
							//Upwards 4
							if (row < 3) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col][row + jelly] == 2'b10) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//Downward 4
							if (row > 2) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col][row - jelly] == 2'b10) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//diagonally up
							if (row < 3 && col < 5) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col + jelly][row + jelly] == 2'b10) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//diagonally down
							if (row > 2 && col < 5) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col + jelly][row - jelly] == 2'b10) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
							
							tally = 1; //reset to 1
							//4 in a row
							if (col < 5) begin
								for (jelly = 1; jelly < 4; jelly = jelly + 1) begin
									if (game_board[col + jelly][row] == 2'b10) begin
										tally = tally + 1;
									end
								end
							end
							
							if (tally == 4) begin
								win_flag <= 1;
							end
						end
					end
				end

				if (!win_flag) begin
					i = x / CELL_WIDTH;
					j = (y / CELL_HEIGHT);
					//grid drawing
					if ((x % CELL_WIDTH < GRID_LINE_WIDTH) || (y % CELL_HEIGHT < GRID_LINE_WIDTH)) begin
						 colour <= GRID_COLOR; // Set color for grid lines
					end else if (i < 8 && j >= 0 && j < 6) begin
						 // Ensure indices are within bounds
						 case (game_board[i][j])
							  2'b01: colour <= 3'b100; // Colour for Player 1
							  2'b10: colour <= 3'b010; // Colour for Player 2
							  default: colour <= 3'b111; // Default background colour
						 endcase
					end else begin
						 colour <= 3'b111; // Default background colour for out-of-bounds
					end

					// Increment x and y logic
					x <= (x < 360) ? x + 1 : 0;
					y <= (x < 360) ? y : (y < 240) ? y + 1 : 0;
					plot <= 1'b1;
				end else if (win_flag) begin
					if (turn % 2 == 0) begin
						colour <= 3'b010;
						GRID_COLOR <= 3'b010;
					end else begin
						colour <= 3'b100;
						GRID_COLOR <= 3'b100;
					end
					// Increment x and y logic
					x <= (x < 360) ? x + 1 : 0;
					y <= (x < 360) ? y : (y < 240) ? y + 1 : 0;
					plot <= 1'b1;
				end

        end
    end
endmodule
