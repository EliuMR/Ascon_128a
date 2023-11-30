library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--k=128
--a=12
--b=6
--r=128 Datablock, textoplano y datos asociados
--Sr=128 bits
--Sc=191
entity Ascon_Cifrador is
  Port (llave: in std_logic_vector(127 downto 0);
        Nonce: in std_logic_vector(127 downto 0);
        datos_Asociados: in std_logic_vector(255 downto 0);
        texto: in std_logic_vector(255 downto 0);
        reset,clock : in std_logic;
        
        texto_Cifrado: out std_logic_vector(255 downto 0);
        Tag:  out std_logic_vector(127 downto 0));
--        tag: out std_logic_vector(127 downto 0));
end Ascon_Cifrador;

architecture Behavioral of Ascon_Cifrador is
component Bloque_Permutacion_Rondas is
  Port (R:in std_logic_vector(127 downto 0);
        C:in std_logic_vector(191 downto 0);
        Ronda:in std_logic;
        S:out std_logic_vector(319 downto 0));
end component;

component Maquina_Estados is
    Port ( reset,clock : in std_logic;
           ronda:out std_logic;
           contador:out std_logic_vector(2 downto 0));   
end component;

component Sc is
  Port (estado_C: in std_logic_vector(2 downto 0);
  
        sc_inicial: in std_logic_vector(191 downto 0);
        c: in std_logic_vector(191 downto 0);
        llave : in std_logic_vector(127 downto 0);

        Cs:out std_logic_vector(191 downto 0));
end component;

component Sr is
  Port (estado_r: in std_logic_vector(2 downto 0);
        sr_inicial:in std_logic_vector(127 downto 0);
        datos_Asociados0:in std_logic_vector(127 downto 0);
        datos_Asociados1:in std_logic_vector(127 downto 0);
        Texto0:in std_logic_vector(127 downto 0);
        Texto1:in std_logic_vector(127 downto 0);
        r:in std_logic_vector(127 downto 0);
        --r6:in std_logic_vector(127 downto 0);
        Rs:out std_logic_vector(127 downto 0));
end component;

component Registro_C is
  Port (C_entrada: in std_logic_vector(191 downto 0);
        C_permitida: out std_logic_vector(191 downto 0);
        clock: in std_logic);
end component;

component Registro_D is
  Port (R_entrada: in std_logic_vector(127 downto 0);
        R_permitida: out std_logic_vector(127 downto 0);
        clock: in std_logic);
end component;


signal Estado_inicial: std_logic_vector(319 downto 0);
alias sr_inicial: std_logic_vector(127 downto 0) is Estado_Inicial(319 downto 192);
alias sc_inicial: std_logic_vector(191 downto 0) is Estado_Inicial(191 downto 0);

signal Estado: std_logic_vector(319 downto 0);
alias r: std_logic_vector(127 downto 0) is Estado(319 downto 192);
alias c: std_logic_vector(191 downto 0) is Estado(191 downto 0);

alias datos_Asociados0: std_logic_vector(127 downto 0) is datos_Asociados(255 downto 128);
alias datos_Asociados1: std_logic_vector(127 downto 0) is datos_Asociados(127 downto 0);

alias Texto0: std_logic_vector(127 downto 0) is texto(255 downto 128);
alias Texto1: std_logic_vector(127 downto 0) is texto(127 downto 0);


signal R_entrada: std_logic_vector(127 downto 0);
signal C_entrada: std_logic_vector(191 downto 0);
signal RondaAB: std_logic;

signal estado_contador: std_logic_vector(2 downto 0);
signal Texto0Cifrado:  std_logic_vector(127 downto 0);
signal Texto1Cifrado:  std_logic_vector(127 downto 0);
signal TextoCifrado: std_logic_vector(255 downto 0);

signal tag_C: std_logic_vector(127 downto 0);

signal C_permitida: std_logic_vector(191 downto 0);
signal R_permitida: std_logic_vector(127 downto 0);
begin
Estado_inicial<="1000000010000000000011000000100000000000000000000000000000000000"&llave&Nonce;

tag_C<=llave xor c(127 downto 0);
Estado_Acual: Maquina_Estados port map (reset=>reset,clock=>clock,ronda=>RondaAB,contador=>estado_contador);
Permutacion: Bloque_Permutacion_Rondas port map (R=>R_permitida,C=>C_permitida,Ronda=>RondaAB,S=>Estado);
registro_sc: Registro_c port map(C_entrada=>C_entrada,C_permitida=>C_permitida,clock=>clock);
registro_sr: Registro_D port map(R_entrada=>R_entrada,R_permitida=>R_permitida,clock=>clock);
state_C: Sc port map(estado_c=>estado_contador,sc_inicial=>sc_inicial,c=>c,llave=>llave,Cs=>C_entrada);

state_R: Sr port map(estado_r=>estado_contador,sr_inicial=>sr_inicial,datos_Asociados0=>datos_Asociados0,datos_Asociados1=>datos_Asociados1,Texto0=>Texto0,Texto1=>Texto1,r=>r,Rs=>R_entrada);

process (estado_contador) begin        
         if estado_contador="100" then 
            Texto0Cifrado<=R_entrada;
         elsif estado_contador="101" then 
            Texto1Cifrado<=R_entrada;
         elsif estado_contador="110" then 
            TextoCifrado<=Texto0Cifrado&Texto1Cifrado;
            Tag<=tag_C;      
         end if;
                      
end process;
texto_cifrado<=TextoCifrado;
end Behavioral;