library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.all;

entity next_start is
    port(
        clock      : in    std_logic := '0';
        pureGReg    : in    std_logic := '0';
        nextN       : out   std_logic_vector (8 downto 0) := (others => '0');  
        nextARG     : out   std_logic_vector (1 downto 0) := (others => '0');
        C9: out std_logic_vector(3 downto 0) :=(others => '0')
    );
    
    signal nextN_Reg: std_logic_vector (8 downto 0) := (others => '0'); 
    signal nextARG_Reg  : std_logic_vector (1 downto 0) := (others => '0');
    signal count9: std_logic_vector(3 downto 0) :=(others => '0');

    signal count27: std_logic_vector(1 downto 0) :=(others => '0');

    signal go3: std_logic := '0';
    signal trivial3: std_logic := '0';
end next_start;


architecture RTL of next_start is
begin
process
begin
    wait until rising_edge(clock);
    if (nextN_Reg="111111110" or go3 ='1') then
        go3 <= '1';
        nextARG_Reg <= "11";
        
    end if;

    if ((nextN_Reg="000000001" and count9="1011" and pureGReg='1') or trivial3='1') then
        trivial3 <= '1';
    end if;
        

    if trivial3 ='1' then
        count9 <= "1010";
        if (nextN_Reg="000000001" and count9="1001") then
            nextN_Reg <= "000000001";
        elsif nextN_Reg="111111100" then
            nextN_Reg <= nextN_Reg;
        elsif nextN_Reg < "101010100" then
            nextN_Reg <= nextN_Reg + 3;
        else
            nextN_Reg <= nextN_Reg + 6;
        end if;
        
    elsif go3 ='1' then
        if pureGReg ='0' then
            nextN_Reg <= nextN_Reg;
        elsif nextN_Reg="111111110" then
            nextN_Reg <= "101010111";
            count9 <= "1001";
        elsif count9="1011" then
            nextN_Reg <="000000001";
        elsif nextN_Reg="111111111" then
            count9 <= "1011";
        elsif pureGReg ='0' then
            nextN_Reg <= nextN_Reg;
        else
            nextN_Reg <= nextN_Reg + 6;
        end if;
    else
        if nextN_Reg="000000000" then
            nextN_Reg <= "000000010";
            nextARG_Reg <= "00";
            count9 <= "0010";
            count27 <= "01";
        elsif pureGReg ='0' then
            nextN_Reg <= nextN_Reg;
            nextARG_Reg <= nextARG_Reg;
            count9 <= count9;

        -- 0
        elsif count9 ="0000" then
            nextN_Reg <= nextN_Reg + 2;
            nextARG_Reg <= "00";
            count9 <= "0010";
        -- 3
        elsif count9 ="0011" then
            nextN_Reg <= nextN_Reg + 2;
            nextARG_Reg <= "00";
            count9 <= count9 + 2;
        -- 5
        elsif count9 ="0101" then
            nextN_Reg <= nextN_Reg + 1;
            nextARG_Reg <= "01";
            count9 <= "0110";
        -- 6
        elsif count9 ="0110" then
            nextN_Reg <= nextN_Reg + 2;
            if count27 ="10" then
                count27 <="00";
                nextARG_Reg <= "00";
            else
                count27 <= count27 + 1;
                if nextN_Reg="000000110" then
                    nextARG_Reg <= "00";
                else
                    nextARG_Reg <= "10";
                end if;
            end if;
            count9 <= "1000";
        -- 8
        elsif count9 ="1000" then
            nextN_Reg <= nextN_Reg + 1;
            nextARG_Reg <= "01";
            count9 <= "0000";
        -- 1, 2, 4, 7
        else
            nextN_Reg <= nextN_Reg + 1;
            nextARG_Reg <= "00";
            count9 <= count9 + '1';
        end if;
    end if;


end process;

nextARG <= nextARG_Reg;
nextN <= nextN_Reg;
C9 <= count9;

end RTL;