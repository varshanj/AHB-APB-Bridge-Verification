class AHB_sequencer extends uvm_sequencer #(AHB_xtn);

    `uvm_component_utils (AHB_sequencer)

    function new (string name = "AHB_sequencer",  uvm_component parent);
        super.new (name, parent);
    endfunction
endclass
