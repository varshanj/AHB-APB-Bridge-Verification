class bridge_env_config extends uvm_object;

    `uvm_object_utils (bridge_env_config)

    bit has_scoreboard;
    bit has_virtual_sequencer;
    int AHB_Agents;
    int APB_Agents;

    AHB_agent_config m_cfg[];
    APB_agent_config s_cfg[];

    function new(string name = "bridge_env_config");
        super.new(name);
    endfunction
endclass
