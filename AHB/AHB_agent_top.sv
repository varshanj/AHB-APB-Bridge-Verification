class AHB_agent_top extends uvm_env;

    `uvm_component_utils (AHB_agent_top)

    bridge_env_config e_cfg;
    AHB_agent_config a_cfg[];
    AHB_agent ahb_agt[];

    extern function new(string name = "AHB_agent_top", uvm_component parent);
    extern function void build_phase(uvm_phase phase); 
endclass

    //////////////////////////////////////////////////////////////////////////////

    function AHB_agent_top::new(string name = "AHB_agent_top", uvm_component parent);
        super.new(name, parent);
    endfunction

    ///////////////////////////////////////////////////////////////////////////////

    function void AHB_agent_top::build_phase(uvm_phase phase);

        if (!uvm_config_db #(bridge_env_config)::get(this, "", "bridge_env_config",e_cfg))
            `uvm_fatal("CONFIG", "getting database failed")

        ahb_agt = new[e_cfg.AHB_Agents];
        a_cfg = new[e_cfg.AHB_Agents];

        foreach(ahb_agt[i]) begin
            ahb_agt[i] = AHB_agent::type_id::create($sformatf("ahb_agt[%0d]",i), this);
            a_cfg[i] = AHB_agent_config::type_id::create($sformatf("a_cfg[%0d]",i));
            a_cfg[i] = e_cfg.m_cfg[i];
            uvm_config_db #(AHB_agent_config)::set(this, $sformatf("ahb_agt[%0d]*",i),"AHB_agent_config",a_cfg[i]);
        end

        super.build_phase(phase);
    endfunction

///****************************************************************************************************///
