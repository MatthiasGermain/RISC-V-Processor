library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG is

    Generic (
        N_REGISTERS : integer := 32;  -- Nombre de registres
        WIDTH       : integer := 32    -- Largeur des registres
    );
	 
    port (
        clk          : in std_logic;                          -- Horloge pour l'écriture
        Write_Enable : in std_logic;                          -- Activation de l'écriture
        RA           : in std_logic_vector(4 downto 0);       -- Adresse du registre à lire sur BusA
        RB           : in std_logic_vector(4 downto 0);       -- Adresse du registre à lire sur BusB
        RW           : in std_logic_vector(4 downto 0);       -- Adresse du registre à écrire
        BusW         : in std_logic_vector(31 downto 0);      -- Données à écrire dans le registre RW
        BusA         : out std_logic_vector(31 downto 0);     -- Données lues du registre RA
        BusB         : out std_logic_vector(31 downto 0)      -- Données lues du registre RB
    );
end entity REG;

architecture Behavioral of REG is

   type reg_array is array (0 to N_REGISTERS-1) of STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	 
	function init_registers return reg_array is 
		variable tmp : reg_array := (others => (others => '0'));
	begin 
		for i in 0 to 31 loop
			tmp(i) := std_logic_vector(to_unsigned(i, N_REGISTERS));
		end loop;
		return tmp;
	end function;
			
	signal registers : reg_array := init_registers;
	
begin

    -- Processus de gestion des écritures dans les registres
    process(Clk)
    begin
        if rising_edge(Clk) then
            if Write_Enable = '1' then
                if to_integer(unsigned(RW)) /= 0 then  -- Éviter d'écrire dans le registre x0
                    registers(to_integer(unsigned(RW))) <= BusW;
                end if;
            end if;
        end if;
    end process;

    -- Lecture des registres RA et RB (asynchrone)
    BusA <= (others => '0') when RA = "00000" else registers(to_integer(unsigned(RA)));  -- x0 toujours 0
    BusB <= (others => '0') when RB = "00000" else registers(to_integer(unsigned(RB)));  -- x0 toujours 0

end architecture Behavioral;
