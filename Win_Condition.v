/*module Win_Condition(
    input [1:0] player,  // Player to check for
    input [1:0] flattened_game_board[0:41],  // Flattened 7x6 game board
    output reg game_over  // Game over flag
);

integer i, j;

always @(*) begin
    game_over = 0;  // Initialize the game over flag

    // Check for horizontal wins
    for (i = 0; i < 6; i = i + 1) begin  // For each row
        for (j = 0; j < 4; j = i + 1) begin  // Check in columns 0 to 3
            if (flattened_game_board[i * 7 + j]     == player &&
                flattened_game_board[i * 7 + j + 1] == player &&
                flattened_game_board[i * 7 + j + 2] == player &&
                flattened_game_board[i * 7 + j + 3] == player) begin
                game_over = 1;
                return;
            end
        end
    end

    // Check for vertical wins
    for (j = 0; j < 7; j = i + 1) begin  // For each column
        for (i = 0; i < 3; i = i + 1) begin  // Check in rows 0 to 2
            if (flattened_game_board[i * 7 + j]     == player &&
                flattened_game_board[(i + 1) * 7 + j] == player &&
                flattened_game_board[(i + 2) * 7 + j] == player &&
                flattened_game_board[(i + 3) * 7 + j] == player) begin
                game_over = 1;
                return;
            end
        end
    end

    // Check for diagonal wins (ascending and descending)
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 4; j = i + 1) begin
            // Ascending diagonal
            if (flattened_game_board[i * 7 + j]         == player &&
                flattened_game_board[(i + 1) * 7 + j + 1] == player &&
                flattened_game_board[(i + 2) * 7 + j + 2] == player &&
                flattened_game_board[(i + 3) * 7 + j + 3] == player) begin
                game_over = 1;
                return;
            end
            // Descending diagonal
            if (flattened_game_board[(i + 3) * 7 + j]     == player &&
                flattened_game_board[(i + 2) * 7 + j + 1] == player &&
                flattened_game_board[(i + 1) * 7 + j + 2] == player &&
                flattened_game_board[i * 7 + j + 3] == player) begin
                game_over = 1;
                return;
            end
        end
    end
end

endmodule
*/