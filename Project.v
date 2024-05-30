
module WaitingTime (input reg [2:0] count , [1:0] Teller , output wire [4:0] addr );
// 3 bit count concatantion with sum of output full adder teller (2 bit ) 
assign addr = {Teller, count };

endmodule
//*************************
module ROM (input [ 4 : 0 ] addr  ,output wire [ 7 : 0 ] data);

reg [ 7 : 0 ] rom [ 31 :0 ];
// dispaly seven segment in 8 Bit 
assign data = rom [addr];
// to get the addresses from MEMEORY
initial begin 
$readmemh("waiting_time.txt" ,rom );
end 

endmodule  


module Teller (input reg teller1, teller2 , teller3 ,output wire [1:0] sum );

//output wire [1:0] sum ** make full adder to 3 Teller  00 01 10 00

assign sum [0] = teller1 ^ teller2 ^ teller3 ;

//S = A  Xor B Xor C
assign sum [1] = (teller1 & teller2) + (teller3 & teller2) + (teller1 & teller3) ;

//Cout = AB + ACin + BCin


endmodule 


module FSM_Moore(clka,reset,up_down,pcount);
input wire clka;  
input up_down,reset;
  parameter s0= 2'b00,
            s1 =2'b01,
            s2 =2'b10,
            s3= 2'b11;
   reg[1:0]state;
   output reg[2:0]pcount;
   always @( posedge reset or posedge clka)
   
   begin
      if(reset)begin
          state = s0;
          pcount <= 3'b000;
      end
      else begin
       case(state)
          s0:
            if (up_down==1)begin
              pcount<= pcount+1;
              state = s1;
            end
         else begin
      pcount<=3'b000;
      state=s0;
           end
          s1: if (up_down==1& pcount <3'b111)begin
                 pcount<= pcount+1;
                state=s1;
              end
             else if(up_down==1 &pcount==3'b111)begin 
             pcount <=3'b111;
                state=s2;
end
             
           else if (up_down==0 &pcount>3'b000)begin
                 pcount<= pcount-1;
                 state = s1;
              end
          else begin 
    pcount=3'b000;
     state=s0;
    end
          s2:
              if (up_down==1&pcount==3'b111)begin
                 pcount<= pcount;
                 state = s2;
              end
              else begin 

    pcount <=pcount-1;
        state =s1;
end
          
            
       endcase 
      end
     end
endmodule


module flags (pcount, empty, full);
  input [2:0] pcount;
  output reg empty, full; 
  always @ (pcount)
  begin
  // If it's 7 it's full and not empty
  if(pcount ==3'b111)
  begin
    full = 1'b1;
    empty = 1'b0;
  end
  // If it's 0 it's empty and not full
  else if(pcount ==3'b000)
    begin
    empty = 1'b1;
    full = 1'b0;
    end
  // Else it's neither
  else
    begin
      full = 1'b0;
      empty = 1'b0;
      end
  end
endmodule
//*******************************
////////////***** control unit *********
// *********************
module Control_Unit(input reg clko, upSensor_downSensor,resetSensor,T1,T2,T3,output wire empty_flag,full_flag,[2:0]count_outo,[7:0]datas);

wire [1:0] teller_num;
wire [4:0] addro;



Teller tall  (T1,T2,T3 , teller_num );

FSM_Moore ll(clko,resetSensor,upSensor_downSensor,count_outo);
WaitingTime wato ( count_outo , teller_num , addro );
 
ROM ko(addro , datas );

flags jk(count_outo, empty_flag, full_flag);

endmodule

//*********************************
// Module to show If the queue is empty or full





module my_test();
  reg clkk,updown,reset,t1,t2,t3;
  wire empty_flago;
  wire full_flago;
  wire [2:0]pcounto;
 wire  [1:0]tcount;

  wire [7:0]dataso;
  initial begin
  clkk=0;
updown =0;
  t1=0;t2=0;t3=0;
  reset=1;#100;
  
  t1=1;t2=0;t3=0;
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1;
  #100; reset = 0; updown = 1; 
t1=1;t2=0;t3=1;
 #100; reset = 0; updown = 1; 
 #100; reset = 0; updown = 1; 
  // 4
  t1=1;t2=1;t3=0;
 #100; reset = 0; updown = 0; 
  #100; reset = 0; updown = 0; 
  #100; reset = 0; updown = 0; 
  // 3 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1; 
  #100; reset = 0; updown = 1;
  #100; reset = 0; updown = 1; 
  // 7
  #100; reset = 0; updown = 0; 
  #100; reset = 0; updown = 0; 
  #100; reset = 0; updown = 0; 
  #100; reset = 0; updown = 0; 
  #100; reset = 0; updown = 0; 
  t1=1;t2=1;t3=1;
   #100; reset = 0; updown = 1; 
#100; reset = 0; updown = 0;
#100; reset = 0; updown = 0;
#100; reset = 0; updown = 0;
#100; reset = 0; updown = 0;
#100; reset = 0; updown = 0;
  #100; reset = 0; updown = 1; 
 #100; reset = 0; updown = 1;
 #100; reset = 0; updown = 1;
  // 4 
  end 
 always 
  #50 clkk = ~clkk;
  initial begin
    $display("                 Time| Clk | Up_Down | Reset  |  T1  |  T2   |  T3 | Empty | Full | Tcount | Pcount | Dataso  ");
    $monitor("%d \t   %b \t   %b \t       %b \t      %b \t     %b \t   %b \t   %b \t     %b \t      %d \t      %d \t    %h ",$time,clkk,updown,reset,t1,t2,t3,empty_flago,full_flago,tcount,pcounto,dataso); 

  end 
  Control_Unit P(clkk,updown,reset,t1,t2,t3,empty_flago,full_flago,pcounto,dataso);
    
endmodule