library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Registro_D is
  Port (R_entrada: in std_logic_vector(127 downto 0);
        R_permitida: out std_logic_vector(127 downto 0);
        clock: in std_logic);
end Registro_D;

architecture Behavioral of Registro_D is

begin
process (clock)
begin
if (clock'event and clock='1') then
    R_permitida<=R_entrada;
end if;
end process;

end Behavioral;
