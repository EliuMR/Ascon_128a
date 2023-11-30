library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Sc is
  Port (estado_C: in std_logic_vector(2 downto 0);
  
        sc_inicial: in std_logic_vector(191 downto 0);
        c: in std_logic_vector(191 downto 0);
        llave : in std_logic_vector(127 downto 0);

        Cs:out std_logic_vector(191 downto 0));
end Sc;

architecture Behavioral of Sc is
signal constante: std_logic_vector(191 downto 0); 
signal cteXorC: std_logic_vector(191 downto 0); 
begin
    with estado_C select constante<=
        "0000000000000000000000000000000000000000000000000000000000000000"&llave when "001",
        "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001" when "011",
        llave&"0000000000000000000000000000000000000000000000000000000000000000" when others;
    cteXorC<= c xor constante;
    with estado_C select Cs<=
        sc_inicial when "000",
        cteXorC when "001",--
        c when "010",
        cteXorC when "011",--
        c when "100",
        cteXorC when others;--
        --c6 when others;
--    process(estado)
--    begin
--        case estado is
--            when "000" =>
--                C<=c0;

--            when "001" =>
--                C<=c1;
--            when "010" =>
--                C<=c2;
--            when "011" =>
--                C<=c3;
--            when "100" =>
--                C<=c4;
--            when others =>
--                C<=c5;
--        end case;
--    end process;

end Behavioral;
