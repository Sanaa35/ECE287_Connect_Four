module debouncer(
    input clk,
    input resetn,
    input noisy_signal,
    output reg debounced_signal
);

    parameter DEBOUNCE_INTERVAL = 1000000; // Adjust as per your clock frequency
    reg [19:0] counter;  // Counter width depends on DEBOUNCE_INTERVAL
    reg last_stable_signal;  // To store the last stable state of the signal

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 0;
            debounced_signal <= 0;
            last_stable_signal <= 0;
        end else begin
            if (noisy_signal != last_stable_signal) begin
                // Signal changed, update last stable signal and reset counter
                last_stable_signal <= noisy_signal;
                counter <= 0;
            end else if (counter < DEBOUNCE_INTERVAL) begin
                // Increment counter as long as the signal remains stable
                counter <= counter + 1;
            end else if (counter == DEBOUNCE_INTERVAL) begin
                // Update debounced signal after the signal has been stable for the interval
                debounced_signal <= last_stable_signal;
            end
            // No need for an 'else' case since the counter will stop incrementing
            // once it reaches the DEBOUNCE_INTERVAL
        end
    end
endmodule

