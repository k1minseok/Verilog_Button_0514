`timescale 1ns / 1ps


module LEDToggle (
    input clk,
    input reset,
    input button,

    output led
);

    wire w_button;


    button U_Button (
        .clk(clk),
        .in (button),
        .out(w_button)
    );

    led_fsm U_FSM (
        .clk(clk),
        .reset(reset),
        .button(w_button),

        .led(led)
    );
endmodule


module led_fsm (
    input clk,
    input reset,
    input button,

    output reg led
);

    parameter LED_OFF = 1'b0, LED_ON = 1'b1;

    reg state, state_next;  // 상태 저장 레지스터

    // state register, 현재 상태 레지스터에 저장 -> Next State Circuit
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= LED_OFF;
        end else begin
            state <= state_next;  // next State
        end
    end


    // Next state Combinational Logic Circuit
    always @(state, button) begin
        state_next = state;
        case (state)
            LED_OFF: begin
                if (button == 1'b1) state_next = LED_ON;
                else
                    state_next = state;    // 버튼 누르지 않으면 상태 변화 없음
            end
            LED_ON: begin
                if (button == 1'b1) state_next = LED_OFF;
                else
                    state_next = state;    // 버튼 누르지 않으면 상태 변화 없음
            end
        endcase
    end


    // Output Combinational Logic Circuit
    // Moore Machine
    always @(state) begin
        led = 1'b0;
        case (state)
            LED_OFF:
            led = 1'b0;  // 상태에 따라 출력 결정(Moore Machine)
            LED_ON: led = 1'b1;
        endcase
    end


    // // Output Combinational Logic Circuit
    // // Mealy Machine
    // always @(state, button) begin
    //     led = 1'b0;
    //     case (state)
    //         LED_OFF: begin
    //             if (button == 1'b1)
    //                 led = 1'b1;         // 출력 결과가 입력과 상태에 따라 결정
    //             else led = 1'b0;
    //         end
    //         LED_ON: begin
    //             if (button == 1'b1) led = 1'b0;
    //             else led = 1'b1;
    //         end
    //     endcase
    // end

endmodule
