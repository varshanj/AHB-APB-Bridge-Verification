`define Has_scoreboard 1
`define Has_virtual_sequencer 1
`define No_of_AHB_agents 1
`define No_of_APB_agents 1

class bridge_test extends uvm_test;

    `uvm_component_utils (bridge_test);

    bridge_env envh;
    bridge_env_config t_cfg;
    AHB_agent_config e_m_cfg[];
    APB_agent_config e_s_cfg[];

    bit has_scoreboard = `Has_scoreboard;
    bit has_virtual_sequencer = `Has_virtual_sequencer;
    int AHB_Agents = `No_of_AHB_agents;
    int APB_Agents = `No_of_APB_agents;

    extern function new (string name = "bridge_test",  uvm_component parent);
    extern function void build_phase (uvm_phase phase);
    extern function void end_of_elaboration_phase (uvm_phase phase);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function bridge_test::new (string name = "bridge_test",  uvm_component parent);
        super.new(name, parent);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void bridge_test::build_phase (uvm_phase phase);

        envh = bridge_env::type_id::create("envh",this);
        t_cfg = bridge_env_config::type_id::create("t_cfg");
        t_cfg.m_cfg = new[AHB_Agents];
        t_cfg.s_cfg = new[APB_Agents];
        e_m_cfg = new[AHB_Agents];
        e_s_cfg = new[APB_Agents];

        foreach (e_m_cfg[i]) begin 
            e_m_cfg[i] = AHB_agent_config::type_id::create($sformatf("e_m_cfg[%0d]",i));

            if(!uvm_config_db #(virtual AHB_intf)::get(this,"","AHB_intf", e_m_cfg[i].vif))
                `uvm_fatal("CONFIG", "getting interface config data failed")

            e_m_cfg[i].is_active = UVM_ACTIVE;
            t_cfg.m_cfg[i] = e_m_cfg[i];
        end

        foreach (e_s_cfg[i]) begin 
            e_s_cfg[i] = APB_agent_config::type_id::create($sformatf("e_s_cfg[%0d]",i));

            if(!uvm_config_db #(virtual APB_intf)::get(this,"","APB_intf", e_s_cfg[i].vif))
                `uvm_fatal("CONFIG", "getting interface config data failed")

            e_s_cfg[i].is_active = UVM_ACTIVE;
            t_cfg.s_cfg[i] = e_s_cfg[i];
        end

        t_cfg.has_scoreboard = this.has_scoreboard;
        t_cfg.has_virtual_sequencer = this.has_virtual_sequencer;
        t_cfg.AHB_Agents = this.AHB_Agents;
        t_cfg.APB_Agents = this.APB_Agents;

        uvm_config_db #(bridge_env_config)::set(this,"*","bridge_env_config",t_cfg);
        super.build_phase(phase);

    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void bridge_test::end_of_elaboration_phase (uvm_phase phase);
        uvm_top.print_topology();
    endfunction


///*********************************************************************************************************//

class extended_test1 extends bridge_test;

    `uvm_component_utils (extended_test1)

    v_seq_ext1 ex_seq1;

    extern function new(string name = "extended_test1", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass

    function extended_test1::new(string name = "extended_test1", uvm_component parent);
        super.new(name,parent);
    endfunction


    function void extended_test1::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task extended_test1::run_phase(uvm_phase phase);
        ex_seq1 = v_seq_ext1::type_id::create("ex_seq1");
        phase.raise_objection(this);
        ex_seq1.start(envh.env_v_seqr);
        phase.drop_objection(this);
    endtask

///*********************************************************************************************************//

class extended_test2 extends bridge_test;

    `uvm_component_utils (extended_test2)

    v_seq_ext2 ex_seq2;

    extern function new(string name = "extended_test2", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass

    function extended_test2::new(string name = "extended_test2", uvm_component parent);
        super.new(name,parent);
    endfunction


    function void extended_test2::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task extended_test2::run_phase(uvm_phase phase);
        ex_seq2 = v_seq_ext2::type_id::create("ex_seq2");
        phase.raise_objection(this);
        ex_seq2.start(envh.env_v_seqr);
        phase.drop_objection(this);
    endtask

///*********************************************************************************************************//

class extended_test3 extends bridge_test;

    `uvm_component_utils (extended_test3)

    v_seq_ext3 ex_seq3;

    extern function new(string name = "extended_test3", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass

    function extended_test3::new(string name = "extended_test3", uvm_component parent);
        super.new(name,parent);
    endfunction


    function void extended_test3::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task extended_test3::run_phase(uvm_phase phase);
        ex_seq3 = v_seq_ext3::type_id::create("ex_seq3");
        phase.raise_objection(this);
        ex_seq3.start(envh.env_v_seqr);
        phase.drop_objection(this);
    endtask

///*********************************************************************************************************//

class extended_test4 extends bridge_test;

    `uvm_component_utils (extended_test4)

    v_seq_ext4 ex_seq4;

    extern function new(string name = "extended_test4", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass

    function extended_test4::new(string name = "extended_test4", uvm_component parent);
        super.new(name,parent);
    endfunction


    function void extended_test4::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task extended_test4::run_phase(uvm_phase phase);
        ex_seq4 = v_seq_ext4::type_id::create("ex_seq4");
        phase.raise_objection(this);
        ex_seq4.start(envh.env_v_seqr);
        phase.drop_objection(this);
    endtask

///*********************************************************************************************************//

