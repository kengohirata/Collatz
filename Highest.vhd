library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.all;

entity Highest is
    port (
        come       : in   std_logic := '0';           
        clock      : in   std_logic := '0';            
        num        : in   std_logic_vector(8 downto 0) := (others => '0');            
        llength     : in   std_logic_vector(7 downto 0) := (others => '0');            
        height     : in   std_logic_vector(15 downto 0) := (others => '0'); 

        first_N    : out  std_logic_vector(8 downto 0) :=  (others => '0');
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
end Highest;

architecture RTL of Highest is
    signal N1    : std_logic_vector(8  downto 0)  :=  (others => '0');
    signal N2    : std_logic_vector(8  downto 0)  :=  (others => '0');
    signal N3    : std_logic_vector(8  downto 0)  :=  (others => '0');
    signal N4    : std_logic_vector(8  downto 0)  :=  (others => '0');

    signal B1    : std_logic_vector(7  downto 0)  :=  (others => '0');
    signal B2    : std_logic_vector(7  downto 0)  :=  (others => '0');
    signal B3    : std_logic_vector(7  downto 0)  :=  (others => '0');
    signal B4    : std_logic_vector(7  downto 0)  :=  (others => '0');
    signal H1    : std_logic_vector(15  downto 0) :=   (others => '0');
    signal H2    : std_logic_vector(15  downto 0) :=   (others => '0');
    signal H3    : std_logic_vector(15  downto 0) :=   (others => '0');
    signal H4    : std_logic_vector(15  downto 0) :=   (others => '0');
begin 
process
    variable continue : std_logic := '1';
    variable shift    : std_logic := '0';
begin
    wait until rising_edge(clock);

    continue := come;
    shift := '0';

    if (continue='1' and height > H1) then
        H1 <= height;
        N1 <= num;
        B1 <= llength;
        shift := '1';
    elsif (continue='1' and height=H1) then
        continue := '0';
        if B1 < llength then
            H1 <= H1;
            N1 <= num;
            B1 <= llength;
        else
            H1 <= H1;
            N1 <= N1;
            B1 <= B1;
        end if;
    else
        H1 <= H1;
        N1 <= N1;
        B1 <= B1;
    end if;


    if shift = '1' then
        H2 <= H1;
        N2 <= N1;
        B2 <= B1;
    elsif (continue='1' and height > H2) then
        H2 <= height;
        N2 <= num;
        B2 <= llength;
        shift := '1';
    elsif (continue='1' and height=H2) then
        continue := '0';
        shift := '0';
        if B2 < llength then
            H2 <= H2;
            N2 <= num;
            B2 <= llength;
        else
            H2 <= H2;
            N2 <= N2;
            B2 <= B2;
        end if;
    else
        H2 <= H2;
        N2 <= N2;
        B2 <= B2;
    end if;


    if shift = '1' then
        H3 <= H2;
        N3 <= N2;
        B3 <= B2;
    elsif (continue='1' and height > H3) then
        H3 <= height;
        N3 <= num;
        B3 <= llength;
        shift := '1';
    elsif (continue='1' and height=H3) then
        continue := '0';
        if B3 < llength then
            H3 <= H3;
            N3 <= num;
            B3 <= llength;
        else
            H3 <= H3;
            N3 <= N3;
            B3 <= B3;
        end if;
    else
        H3 <= H3;
        N3 <= N3;
        B3 <= B3;
    end if;


    if shift = '1' then
        H4 <= H3;
        N4 <= N3;
        B4 <= B3;
    elsif (continue='1' and height > H4) then
        H4 <= height;
        N4 <= num;
        B4 <= llength;
    elsif (continue='1' and height=H4) then
        if B4 < llength then
            H4 <= H4;
            N4 <= num;
            B4 <= llength;
        else
            H4 <= H4;
            N4 <= N4;
            B4 <= B4;
        end if;
    else
        H4 <= H4;
        N4 <= N4;
        B4 <= B4;
    end if;

end process;



first_N    <= N1  ;
first_B    <= B1  ;
first_H    <= H1  ;
second_N   <= N2  ;
second_B   <= B2  ;
second_H   <= H2  ;
third_N    <= N3  ;
third_B    <= B3  ;
third_H    <= H3  ;
fourth_N   <= N4  ;
fourth_B   <= B4  ;
fourth_H   <= H4  ;


end RTL;
