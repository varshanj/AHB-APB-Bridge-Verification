package bridge_pkg;

    import uvm_pkg::*;

    `include "uvm_macros.svh"

    `include "AHB_xtn.sv"
    `include "APB_xtn.sv"
    `include "AHB_agent_config.sv"
    `include "APB_agent_config.sv"
    `include "bridge_env_config.sv"

    `include "AHB_driver.sv"
    `include "AHB_monitor.sv"
    `include "AHB_sequencer.sv"
    `include "AHB_sequence.sv"
    `include "AHB_agent.sv"
    `include "AHB_agent_top.sv"

    `include "APB_driver.sv"
    `include "APB_monitor.sv"
    `include "APB_sequencer.sv"
    `include "APB_sequence.sv"
    `include "APB_agent.sv"
    `include "APB_agent_top.sv"

    `include "bridge_virtual_sequencer.sv"
    `include "bridge_virtual_sequence.sv"
    `include "bridge_scoreboard.sv"

    `include "bridge_env.sv"

    `include "bridge_test.sv"

endpackage
