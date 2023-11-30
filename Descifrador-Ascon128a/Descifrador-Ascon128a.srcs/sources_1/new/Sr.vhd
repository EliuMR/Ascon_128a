library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Sr is
  Port (estado_r: in std_logic_vector(2 downto 0);
  
        sr_inicial:in std_logic_vector(127 downto 0);
        datos_Asociados0:in std_logic_vector(127 downto 0);
        datos_Asociados1:in std_logic_vector(127 downto 0);
        Texto0_cifrado:in std_logic_vector(127 downto 0);
        Texto1_cifrado:in std_logic_vector(127 downto 0);
        r:in std_logic_vector(127 downto 0);
        --r6:in std_logic_vector(127 downto 0);
        Rs:out std_logic_vector(127 downto 0));
end Sr;

architecture Behavioral of Sr is
signal absorbidos: std_logic_vector(127 downto 0);
signal absorbidosXor: std_logic_vector(127 downto 0);
begin
    with estado_r select absorbidos <=
        datos_Asociados0 when "001",
        datos_Asociados1 when others;
        --Texto0 when "011",
       -- Texto1 when others;
    absorbidosXor<=absorbidos xor r;
    
    with estado_r select Rs<=
        sr_inicial when "000",
        absorbidosXor when "001", --
        absorbidosXor when "010",--
        Texto0_cifrado when "011",--
        Texto1_cifrado when "100",--
        r when others;
        --r6 when others;
end Behavioral;