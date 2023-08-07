class AHB_sequence extends uvm_sequence #(AHB_xtn);

    `uvm_object_utils (AHB_sequence)

    function new(string name = "AHB_sequence");
        super.new(name);
    endfunction
 
endclass

///***********************************************************************///

class single_transfer_seq extends AHB_sequence;

    `uvm_object_utils (single_transfer_seq)

    function new(string name = "single_transfer_seq");
        super.new(name);
    endfunction

    task body();
        req = AHB_xtn::type_id::create("req");
        repeat(10) begin
            start_item(req);
            assert(req.randomize with {Hwrite == 1;
                                       Hburst == 3'b000;
                                       Htrans == 2'b10;});
            finish_item(req);
        end

        start_item(req); //idle condition
        assert(req.randomize with {Htrans == 2'b00;});
        finish_item(req);

    endtask

endclass

///***********************************************************************///

class unspecified_transfer_seq extends AHB_sequence;

    `uvm_object_utils (unspecified_transfer_seq)

    logic [31:0] addr;
    logic [2:0] size;
    int len;

    function new(string name = "unspecified_transfer_seq");
        super.new(name);
    endfunction

    task body();
        req = AHB_xtn::type_id::create("req");

        start_item(req);
        assert(req.randomize with {Hwrite == 1;
                                   Hburst == 3'b001;
                                   length == 10;
                                   Htrans == 2'b10;});
        finish_item(req);

        addr = req.Haddr;
        size = req.Hsize;
        len = req.length;

        for (int i = len-1; i > 0; i--) begin 

            addr = addr + (2**size);
            start_item(req);
            assert(req.randomize with {Hwrite == 1;
                                       Hsize  == size;
                                       Haddr  == addr;
                                       length == i;
                                       Hburst == 3'b001;
                                       Htrans == 2'b11;});
            finish_item(req);
        end

        start_item(req);
        assert(req.randomize with {Htrans == 2'b00;});
        finish_item(req);

    endtask
endclass

///***********************************************************************///

class incremental_transfer_seq extends AHB_sequence;

    `uvm_object_utils (incremental_transfer_seq)

    logic [31:0] addr;
    logic [2:0] size;
    logic [2:0] burst;
    local int loop;

    function new(string name = "incremental_transfer_seq");
        super.new(name);
    endfunction

    task body();
        req = AHB_xtn::type_id::create("req");

        start_item(req);
        assert(req.randomize with {Hwrite == 1;
                                   Hburst == 3;//
                                   Hsize == 0;//
                                   //Hburst inside {3,5,7};
                                   Htrans == 2'b10;});
        finish_item(req);

        addr = req.Haddr;
        size = req.Hsize;
        burst = req.Hburst;

        case (burst) 
            3: loop = 3;
            5: loop = 7;
            7: loop = 15;
        endcase

        for (int i = 0; i < loop; i++) begin 

            addr = addr + (2**size);
            start_item(req);
            assert(req.randomize with {Hwrite == 1;
                                       Hsize  == size;
                                       Haddr  == addr;
                                       Hburst == burst;
                                       Htrans == 2'b11;});
            finish_item(req);
        end

        start_item(req);
        assert(req.randomize with {Htrans == 2'b00;});
        finish_item(req);

    endtask
endclass

///***********************************************************************///

class wrap_transfer_seq extends AHB_sequence;

    `uvm_object_utils (wrap_transfer_seq)

    logic [31:0] addr;
    logic [2:0] size;
    logic [2:0] burst;

    function new(string name = "wrap_transfer_seq");
        super.new(name);
    endfunction

    task body();
        req = AHB_xtn::type_id::create("req");

        start_item(req);
        assert(req.randomize with {Hwrite == 1;
                                   Hburst == 2;//
                                   Hsize == 0;//
                                   Hburst inside {2,4,6};
                                   Htrans == 2'b10;});
        finish_item(req);

        addr = req.Haddr;
        size = req.Hsize;
        burst = req.Hburst;

        if (burst == 2) begin //wrap4
            for (int i = 0; i < 3; i++) begin 
                if (size == 0) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {addr[31:2], addr[1:0] + 1};});
                    finish_item(req);
                    addr = req.Haddr;
                end

                if (size == 1) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:3], Haddr[2:0] + 2};});
                    finish_item(req);
                end

                if (size == 2) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:4], Haddr[3:0] + 4};});
                    finish_item(req);
                end
            end
        end

        if (burst == 4) begin //wrap8
            for (int i = 0; i < 7; i++) begin 
                if (size == 0) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:3], Haddr[2:0] + 1};});
                    finish_item(req);
                end

                if (size == 1) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:4], Haddr[3:0] + 2};});
                    finish_item(req);
                end

                if (size == 2) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:5], Haddr[4:0] + 4};});
                    finish_item(req);
                end
            end
        end


        if (burst == 6) begin //wrap16
            for (int i = 0; i < 15; i++) begin 
                if (size == 0) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:4], Haddr[3:0] + 1};});
                    finish_item(req);
                end

                if (size == 1) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:5], Haddr[4:0] + 2};});
                    finish_item(req);
                end

                if (size == 2) begin 
                    start_item(req);
                    assert(req.randomize with {Hwrite == 1;
                                               Hsize  == size;
                                               Hburst == burst;
                                               Htrans == 2'b11;
                                               Haddr  == {Haddr[31:6], Haddr[5:0] + 4};});
                    finish_item(req);
                end
            end
        end

        start_item(req);
        assert(req.randomize with {Htrans == 2'b00;});
        finish_item(req);

    endtask
endclass


///***********************************************************************///

/*
class wrap_transfer_seq extends AHB_sequence;

    `uvm_object_utils (wrap_transfer_seq)

    logic [31:0] addr;
    logic [2:0] size;
    logic [2:0] burst;
    local int loop;
    local int value;
    local int point;

    function new(string name = "wrap_transfer_seq");
        super.new(name);
    endfunction

    task body();
        req = AHB_xtn::type_id::create("req");

        start_item(req);
        assert(req.randomize with {Hwrite == 1;
                                   Hburst inside {2,4,6};
                                   Htrans == 2'b10;});
        finish_item(req);

        addr = req.Haddr;
        size = req.Hsize;
        burst = req.Hburst;

        case (burst) 
            2: begin 
                loop = 3; 
                value = 0; 
               end
            4: begin 
                loop = 7; 
                value = 1; 
               end
            6: begin 
                loop = 15; 
                value = 2; 
               end
        endcase

        point = 2 + value + size;

        for (int i = 0; i < loop; i++) begin 

            addr = {addr[31 : point], 
                    addr[point-1 : 0] + (2**size)};

            start_item(req);
            assert(req.randomize with {Hwrite == 1;
                                       Hsize  == size;
                                       Hburst == burst;
                                       Htrans == 2'b11;
                                       Haddr  == addr;});
            finish_item(req);
        end

        start_item(req);
        assert(req.randomize with {Htrans == 2'b00;});
        finish_item(req);

    endtask
endclass
*/
///***********************************************************************///

