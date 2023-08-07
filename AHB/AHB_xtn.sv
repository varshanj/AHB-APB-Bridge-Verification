class AHB_xtn extends uvm_sequence_item;

    `uvm_object_utils (AHB_xtn)

    rand logic [31:0] Hwdata;
    rand logic [31:0] Haddr;
    rand logic [2:0] Hsize;
    rand logic [2:0] Hburst;
    rand logic [1:0] Htrans;
    rand logic Hwrite;

    rand int length;

    logic [31:0] Hrdata;

    constraint Valid_Size {Hsize inside {[0:2]};}

    constraint Valid_Length {(2**Hsize) * length <= 1024;}

    constraint Valid_Addr1 {Hsize == 1 -> (Haddr % 2) == 0;
                            Hsize == 2 -> (Haddr % 4) == 0;}

    constraint Valid_Addr2 {Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
                                          [32'h8400_0000 : 32'h8400_03ff],
                                          [32'h8800_0000 : 32'h8800_03ff],
                                          [32'h8c00_0000 : 32'h8c00_03ff]};}

    extern function new(string name = "AHB_xtn");
    extern function void do_print (uvm_printer printer);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function AHB_xtn::new(string name ="AHB_xtn");
        super.new(name);
    endfunction: new

    /////////////////////////////////////////////////////////////////////////////////////

    function void AHB_xtn::do_print(uvm_printer printer);
        printer.print_field("Haddr",  Haddr,  32, UVM_HEX);
        printer.print_field("Hwdata", Hwdata, 32, UVM_HEX); 
        printer.print_field("Hsize",  Hsize,  3,  UVM_DEC);
        printer.print_field("Hburst", Hburst, 3,  UVM_BIN);
        printer.print_field("Htrans", Htrans, 2,  UVM_BIN);
        printer.print_field("Hwrite", Hwrite, 1,  UVM_BIN);
        printer.print_field("Hrdata", Hrdata, 32, UVM_DEC);
        //printer.print_field("Length", length, 32, UVM_DEC);
    endfunction

///****************************************************************************************************///

