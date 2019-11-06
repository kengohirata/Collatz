library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.all;


entity Collatz is
    port(
        SysClk      : in    std_logic := '0';
        NowNum      : out   std_logic_vector (8 downto 0) := (others => '0');
        Ncount      : out   std_logic_vector (3 downto 0) := (others => '0');
        Aout        : out   std_logic_vector (16 downto 0) := (others => '0');
        Bout        : out   std_logic_vector (7 downto 0) := (others => '0');
        Height      : out   std_logic_vector (16 downto 0) := (others => '0');
        pureGoNext  : out   std_logic := '1';
        evilGoNext  : out   std_logic := '1';
        Wren1       : out   std_logic :='0';
        Wren2       : out   std_logic :='0';
        ADDR        : out   std_logic_vector(8 downto 0) :=(others => '0');
        Done        : out   std_logic := '0';
        D_Bmon      : out   std_logic_vector (7 downto 0) := (others => '0');
        D_Hmon      : out   std_logic_vector (15 downto 0) := (others => '0');


        
        first_N    : out  std_logic_vector(8  downto 0) :=  (others => '0');
        first_B    : out  std_logic_vector(7  downto 0) :=  (others => '0');
        first_H    : out  std_logic_vector(15 downto 0):=   (others => '0');
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
end Collatz;

architecture RTL of Collatz is
    component ram1port
        port(
		    address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0) := (others => '0');
		    clock		: IN STD_LOGIC;
		    data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0) := (others => '0');
		    wren		: IN STD_LOGIC :='1';
		    q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0) := (others => '0')
        );
    end component;
    
    component Highest
        port (
            come       : in   std_logic := '0';           
            clock      : in   std_logic := '0';            
            num        : in   std_logic_vector(8 downto 0) := (others => '0');            
            llength     : in   std_logic_vector(7 downto 0) := (others => '0');            
            height     : in   std_logic_vector(15 downto 0) := (others => '0'); 
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
            fourth_H   : out  std_logic_vector(15 downto 0) :=  (others => '0')     
        );
    end component;

    component next_start
        port(
            clock      : in    std_logic := '0';
            pureGReg    : in  std_logic := '0';
            nextN       : out   std_logic_vector (8 downto 0) := (others => '0');  
            nextARG     : out   std_logic_vector (1 downto 0) := (others => '0');
            C9          : out std_logic_vector(3 downto 0) :=(others => '0')
        );
    end component;

    signal START: std_logic :='1';

    signal NReg: std_logic_vector(8 downto 0) :=(others => '0');
    signal NC  : std_logic_vector(3 downto 0) :=(others => '0');
    signal AReg: std_logic_vector(16 downto 0) :=(others => '0');
    signal BReg: std_logic_vector(7 downto 0) :=(others => '0');
    signal HReg: std_logic_vector(16 downto 0) :=(others => '0');
    signal evilGReg: std_logic :='0';
    signal pureGReg: std_logic :='0';
    signal WReg1: std_logic := '0';
    signal WReg2: std_logic := '0';
    signal address: std_logic_vector(8 downto 0) :=(others => '0');
    signal Data: std_logic_vector(23 downto 0) :=(others => '0');

    signal exitdone : std_logic := '0';
    signal q: std_logic_vector(23 downto 0) := (others => '0'); 
    signal wait_N: std_logic_vector(8 downto 0) :=(others => '0');
    signal wait_B: std_logic_vector(7 downto 0) :=(others => '0');
    signal wait_H: std_logic_vector(16 downto 0) :=(others => '0');

    signal nextN: std_logic_vector (8 downto 0) := (others => '0');
    signal nextARG: std_logic_vector (1 downto 0) := (others => '0');

    signal come : std_logic := '0';
    signal highestN: std_logic_vector(8 downto 0) :=(others => '0');
    signal wwaaiitt_N: std_logic_vector(8 downto 0) :=(others => '0');
begin
    RAM: ram1port port map(
        address =>  address,
        clock => SysClk,
        data => Data,
        wren => WReg2,
        q => q
    );

    Topfour: Highest port map(
        come      => come ,
        clock     => SysClk ,
        num       => highestN,
        llength    => Data(23 downto 16),
        height    => Data(15 downto 0),
        first_N   => first_N ,
        first_B   => first_B  ,
        first_H   => first_H  ,
        second_N  => second_N ,
        second_B  => second_B ,
        second_H  => second_H ,
        third_N   => third_N  ,
        third_B   => third_B  ,
        third_H   => third_H  ,
        fourth_N  => fourth_N ,
        fourth_B  => fourth_B ,
        fourth_H  => fourth_H 
    );

    Ncontrol: next_start port map(
        clock    => SysClk,          
        pureGReg => pureGReg,      
        nextN    => nextN   ,          
        nextARG  => nextARG,
        C9 => NC
    );



process 
    variable ThreeOneA: std_logic_vector(17 downto 0) :=(others => '0');
    variable Digit: std_logic_vector(4 downto 0) :=(others => '0');
    variable A_variable: std_logic_vector(17 downto 0) :=(others => '0');
    variable A_7: std_logic_vector(11 downto 0) :=(others => '0');

    variable q_B: std_logic_vector(7 downto 0) :=(others => '0');
    variable q_H: std_logic_vector(15 downto 0) :=(others => '0');

begin
    wait until rising_edge(SysClk);

    -- START
    START <= '0';

    --- NReg
    if START='1' then
        NReg <= "000000000";
    elsif (pureGReg='1') then
        NReg <= nextN;
    else
        NReg <= NReg;
    end if;

    --- AReg
    if START='1' then
        A_variable :="000000000000000001";
    elsif (pureGReg='1' and (not (NC="1010"))) then
        A_variable :=("00000000" & nextN & '1');
    elsif (nextARG = "01") then
    
        A_variable := ('0' & NReg & "01000000")
                        + ("000" & NReg & "010000")
                        + ("00000" & NReg & "0100")
                        + ("0000000" & NReg & "01")
                        + ("000000000" & NReg);
        A_variable := ("00000000" & A_variable(17 downto 8)) + 1;

    elsif (nextARG ="10") then
    
        A_7 := ("000000" & NReg(8 downto 3))
                + ("000" & NReg)
                + ("00" & NReg & '0')
                + ('0' & NReg & "00");
        A_variable := "00000000" & A_7(11 downto 6) & "1011";

    else
        if NC="1010" then
            ThreeOneA := ("000000000" & nextN) + ("00000000" & nextN & '0') + 2;
        else
            ThreeOneA := ('0' & AReg) + (AReg & '0') + 2;
        end if;

        if (ieee.std_logic_unsigned."=" (ThreeOneA(14 downto 0), "000000000000000")) then
            Digit(4) := '1';
        else 
            Digit(4) := '0';
        end if;
        
        if ((ieee.std_logic_unsigned."=" (ThreeOneA(7 downto 0), "00000000"))
                    and (not (ieee.std_logic_unsigned."=" (ThreeOneA(14 downto 8), "0000000")))) then
            Digit(3) := '1';
        else 
            Digit(3) := '0';
        end if;
        
        if  (((ieee.std_logic_unsigned."=" (ThreeOneA(3 downto 0), "0000")) and (ThreeOneA(4) ='1' or ThreeOneA(5)='1' or ThreeOneA(6)='1' or ThreeOneA(7)='1'))
                    or ((ieee.std_logic_unsigned."=" (ThreeOneA(11 downto 0), "000000000000")) and (ThreeOneA(12)='1' or ThreeOneA(13)='1' or ThreeOneA(14)='1' or ThreeOneA(15)='1')))
        then
            Digit(2) := '1';
        else 
            Digit(2) := '0';
        end if;

        if  ((ieee.std_logic_unsigned."=" (ThreeOneA(1 downto 0), "00")) and (ThreeOneA(2)='1' or ThreeOneA(3)='1'))
                    or ((ieee.std_logic_unsigned."=" (ThreeOneA(5 downto 0), "000000")) and (ThreeOneA(6)='1' or ThreeOneA(7)='1'))
                    or ((ieee.std_logic_unsigned."=" (ThreeOneA(9 downto 0), "0000000000")) and (ThreeOneA(10)='1' or ThreeOneA(11)='1'))
                    or ((ieee.std_logic_unsigned."=" (ThreeOneA(13 downto 0), "00000000000000")) and (ThreeOneA(14)='1' or ThreeOneA(15)='1'))
        then
            Digit(1) := '1';
        else 
            Digit(1) := '0';
        end if;

        if  (ieee.std_logic_unsigned."=" (ThreeOneA(1 downto 0), "10"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(3 downto 0), "1000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(5 downto 0), "100000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(7 downto 0), "10000000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(9 downto 0), "1000000000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(11 downto 0), "100000000000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(13 downto 0), "10000000000000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(15 downto 0), "1000000000000000"))
                    or (ieee.std_logic_unsigned."=" (ThreeOneA(17 downto 0), "100000000000000000"))                            
        then
            Digit(0) := '1';
        else 
            Digit(0) := '0';
        end if;
        
        A_variable := ThreeOneA;
        if Digit(0) = '1' then
            A_variable := '0' & A_variable(17 downto 1);
        end if;
        if Digit(1) = '1' then
            A_variable := "00" & A_variable(17 downto 2);
        end if;
        if Digit(2) = '1' then
            A_variable := "0000" & A_variable(17 downto 4);
        end if;
        if Digit(3) = '1' then
            A_variable := "00000000" & A_variable(17 downto 8);
        end if;
        if Digit(4) = '1' then
            A_variable := "0000000000000000" & A_variable(17 downto 16);
        end if;
    end if;
    AReg <= A_variable(17 downto 1);

    --- BReg
    if NC="1010" then
        BReg <= "00000010" + Digit;
    elsif (pureGReg='1' or START='1') then
        BReg <= "00000000";
    elsif nextARG = "01" then
        BReg <= "11111110";
    elsif nextARG ="10" then
        BReg <= "11111011";
    else
        BReg <= BReg + Digit + 2;
    end if;

    --- HReg
    if pureGReg = '1' then
        HReg <= "00000000" & nextN;
    elsif A_variable(17 downto 1) > HReg then
        HReg <= A_variable(17 downto 1);
    else
        HReg <= HReg;
    end if;

    --- pureGReg
    if (((nextARG(0)='0' or nextARG(1)='0') and NReg >= (A_variable(17 downto 1))) or
     (START='1') or (nextARG="11" and (A_variable(17 downto 10) ="00000000") and pureGReg='0')
     or NC="1010" or exitdone='1'
     ) then
        pureGReg <= '1';
    else
        pureGReg <= '0';
    end if;

    --- evilGReg, wreg1
    if (pureGReg ='1' and WReg2='1') then
        evilGReg <='1';
        WReg1 <='0';
    elsif (pureGReg ='1' or evilGReg='1') then
        evilGReg <='0';
        WReg1 <='1';
    else
        evilGReg <='0';
        WReg1 <='0';
    end if;
    
    --- wreg2
    if (exitdone ='1' or (WReg2='1' and address="111111111")) then
        WReg2 <= '0';
        if NC ="1010" then
            come <= '1';
        else
            come <= '0';
        end if;
    else
        WReg2 <= WReg1;
        if (NC="1010" or WReg1='1') then
            come <= '1';
        else
            come <= '0';
        end if;
    end if;

    --- exitdone
    if ((WReg2='1' and address="111111111") or exitdone ='1') then
        exitdone <='1';
    else
        exitdone <='0';
    end if;

    --- address
    if (START='1') then
        address <= "000000000";
        highestN <="000000000";
    elsif NC="1010" then
        address <= A_variable(9 downto 1);
        highestN <= wait_N;
    elsif WReg1='1' then
        address <= wait_N;
        highestN <=wait_N;
    elsif pureGReg ='1' then
        address <= AReg(8 downto 0);
        highestN<= AReg(8 downto 0);
    else
        address <= A_variable(9 downto 1);
        highestN <= A_variable(9 downto 1);
    end if;
    
    --- q_B, q_H
    if START='1' then
        q_B := "00000000";
        q_H := "0000000000000000";
    else
        q_B := q(23 downto 16);
        q_H := q(15 downto 0);
    end if;

    --- D_B
    if (START='1') then
        Data(23 downto 16) <= "00000001";
    elsif (NC="1011" and WReg2='1') then
        Data(23 downto 16) <= "00000000";
    else
        Data(23 downto 16) <= wait_B + q_B;
    end if;

    --- D_H
    if wait_H < q_H then
        Data(15 downto 0) <= q_H; 
    elsif (NC="1011" and WReg2='1') then
        Data(15 downto 0) <= "0000000000000000";
    else
        Data(15 downto 0) <= wait_H(15 downto 0);
    end if;

    --- wait_N, wait_B, wait_H
    if (pureGReg='1' or NC="1010") then
        wait_N <= NReg;
        wait_B <= BReg;
        wait_H <= HReg;
    else
        wait_N <= wait_N;
        wait_B <= wait_B;
        wait_H <= wait_H;
    end if;


end process;

NowNum        <= NReg    ;  
Ncount        <= NC      ;
Aout          <= AReg    ;   
Bout          <= BReg    ;       
Height        <= HReg   ;    
pureGoNext    <= pureGReg;        
evilGoNext    <= evilGReg;          
Wren1         <= WReg1   ;   
Wren2         <= WReg2   ;         
ADDR          <= address ; 
Done          <= exitdone    ;
D_Bmon        <= Data(23 downto 16)  ;
D_Hmon        <= Data(15 downto 0) ;

NNN <= nextN;

end RTL;