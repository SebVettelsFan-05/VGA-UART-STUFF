module image_rom (
    input logic [9:0] v_count,
    input logic [9:0] h_count,
    output logic [11:0] rgb_colour
);
    const [11:0] array[0:479][0:639] = '{
        '{12'hffe, 12'hffe,},
        '{12'hffe, 12'hffe,},
    };

    assign rgb_colour = array[v_count][h_count];
endmodule