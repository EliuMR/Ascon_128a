library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Registro_C is
  Port (C_entrada: in std_logic_vector(191 downto 0);
        C_permitida: out std_logic_vector(191 downto 0);
        clock: in std_logic);
end Registro_C;

architecture Behavioral of Registro_C is

begin
process (clock)
begin
if (clock'event and clock='1') then
    C_permitida<=C_entrada;
end if;
end process;
end Behavioral;
