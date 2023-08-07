class APB_agent_config extends uvm_object;

    `uvm_object_utils (APB_agent_config)

    virtual APB_intf vif;
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "APB_agent_config");
        super.new(name);
    endfunction
endclass
