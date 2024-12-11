module inTriangle (
    input logic [15:0] alpha, beta, gamma,
    output logic valid
);
    always_comb begin
        valid = (alpha >= 0 && beta >= 0 && gamma >= 0 && alpha <= 1 && beta <= 1 && gamma <= 1);
    end
endmodule


