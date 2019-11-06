library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.all;

entity TopCollatz is
end TopCollatz;

architecture SIM of TopCollatz is
    signal SysClk:       std_logic := '0';
    signal NowNum:       std_logic_vector (9 downto 0) := (others => '0');
    signal Ncount:       std_logic_vector(3 downto 0) :=(others => '0');

    signal Aout:         std_logic_vector (17 downto 0) := (others => '0');
    signal Bout:         std_logic_vector (7 downto 0) := (others => '0');
    signal Height:       std_logic_vector (17 downto 0) := (others => '0');
    signal pureGoNext:   std_logic := '1';
    signal evilGoNext:   std_logic := '1';
    signal Wren1:        std_logic :='0';
    signal Wren2:        std_logic :='0';
    signal ADDR:         std_logic_vector(8 downto 0) :=(others => '0');
    signal Done:         std_logic := '0';
    signal D_Bmon:       std_logic_vector (7 downto 0) := (others => '0');
    
    
    signal D_Hmon:       std_logic_vector (16 downto 0) := (others => '0');



    signal    first_N    :   std_logic_vector(9  downto 0) :=  (others => '0');
    signal    first_B    :   std_logic_vector(7  downto 0) :=  (others => '0');
    signal    first_H    :   std_logic_vector(17  downto 0):=   (others => '0');
    signal    second_N   :   std_logic_vector(9  downto 0) :=  (others => '0');                
    signal    second_B   :   std_logic_vector(7  downto 0) :=  (others => '0');                
    signal    second_H   :   std_logic_vector(17 downto 0) :=  (others => '0');                
    signal    third_N    :   std_logic_vector(9  downto 0) :=  (others => '0');               
    signal    third_B    :   std_logic_vector(7  downto 0) :=  (others => '0');               
    signal    third_H    :   std_logic_vector(17 downto 0) :=  (others => '0');               
    signal    fourth_N   :   std_logic_vector(9  downto 0) :=  (others => '0');             
    signal    fourth_B   :   std_logic_vector(7  downto 0) :=  (others => '0');              
    signal    fourth_H   :   std_logic_vector(17 downto 0) :=  (others => '0');

    signal    H1         :   std_logic_vector(15 downto 0) :=  (others => '0');
    signal    H2         :   std_logic_vector(15 downto 0) :=  (others => '0');
    signal    H3         :   std_logic_vector(15 downto 0) :=  (others => '0');
    signal    H4         :   std_logic_vector(15 downto 0) :=  (others => '0');

    signal    NNN        : std_logic_vector(8  downto 0) :=  (others => '0');
        
    component Collatz
        
        port(
        SysClk:    in    std_logic := '0';
        NowNum:    out   std_logic_vector (8 downto 0) := (others => '0');
        Ncount      : out   std_logic_vector (3 downto 0) := (others => '0');
        Aout:      out   std_logic_vector (16 downto 0) := (others => '0');
        Bout:      out   std_logic_vector (7 downto 0) := (others => '0');
        Height:    out   std_logic_vector (16 downto 0) := (others => '0');
        pureGoNext:out   std_logic := '1';
        evilGoNext:out   std_logic := '1';
        Wren1:     out   std_logic :='0';
        Wren2:     out   std_logic :='0';
        ADDR:      out   std_logic_vector(8 downto 0) :=(others => '0');
        Done:      out   std_logic := '0';
        D_Bmon:    out   std_logic_vector (7 downto 0) := (others => '0');
        D_Hmon:    out   std_logic_vector (15 downto 0) := (others => '0');


        first_N    : out  std_logic_vector(8  downto 0) :=  (others => '0');
        first_B    : out  std_logic_vector(7  downto 0) :=  (others => '0');
        first_H    : out  std_logic_vector(15  downto 0):=   (others => '0');
        second_N   : out  std_logic_vector(8  downto 0) :=  (others => '0');                
        second_B   : out  std_logic_vector(7  downto 0) :=  (others => '0');                
        second_H   : out  std_logic_vector(15 downto 0) :=  (others => '0');                
        third_N    : out  std_logic_vector(8  downto 0) :=  (others => '0');               
        third_B    : out  std_logic_vector(7  downto 0) :=  (others => '0');               
        third_H    : out  std_logic_vector(15 downto 0) :=  (others => '0');               
        fourth_N   : out  std_logic_vector(8  downto 0) :=  (others => '0');             
        fourth_B   : out  std_logic_vector(7  downto 0) :=  (others => '0');              
        fourth_H   : out  std_logic_vector(15 downto 0) :=  (others => '0');     
        

        NNN        : out  std_logic_vector(8  downto 0) :=  (others => '0')
        );
    end component;

begin
    CL: Collatz port map(
        SysClk      =>      SysClk     ,
        NowNum    =>      NowNum (9 downto 1)      , 
        Ncount    =>      Ncount       ,
        Aout      =>      Aout   (17 downto 1)      ,  
        Bout      =>      Bout         ,    
        Height    =>      Height (17 downto 1)      ,  
        pureGoNext =>      pureGoNext  ,    
        evilGoNext =>      evilGoNext  ,   
        Wren1     =>      Wren1        ,  
        Wren2     =>      Wren2       ,
        ADDR      =>      ADDR         , 
        Done      =>      Done         ,  
        D_Bmon    =>      D_Bmon       ,  
        D_Hmon    =>      D_Hmon  (16 downto 1) ,    

                
        first_N   => first_N (9 downto 1),
        first_B   => first_B  ,
        first_H   => H1,
        second_N  => second_N (9 downto 1),
        second_B  => second_B ,
        second_H  => H2,
        third_N   => third_N (9 downto 1),
        third_B   => third_B  ,
        third_H   => H3,
        fourth_N  => fourth_N(9 downto 1) ,
        fourth_B  => fourth_B ,
        fourth_H  => H4  ,

        NNN => NNN
        );

process begin
    SysClk <= '1';
    wait for 10 ns;
    SysClk <='0';
    wait for 10 ns;
end process;


first_N (0) <= '1';
second_N (0) <= '1';
third_N (0) <= '1';
fourth_N (0) <= '1';
first_H(17 downto 1) <= (H1 & '0') + ('0' + H1) + "10";
second_H(17 downto 1) <= (H2 & '0') + ('0' + H2) + "10";
third_H(17 downto 1) <= (H3 & '0') + ('0' + H3) + "10";
fourth_H(17 downto 1) <= (H4 & '0') + ('0' + H4) + "10";
first_H(0)   <= '0';
second_H(0)  <= '0';
third_H(0)  <= '0';
fourth_H(0)  <= '0';
Height(0) <= '1';
NowNum(0) <= '1';
Aout(0) <= '1';
D_Hmon(0) <= '1';
end;