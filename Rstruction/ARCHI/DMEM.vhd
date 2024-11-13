library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMEM is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 3  -- 8 mots
    );
    port 
    (
        clk   : in std_logic;
        addr  : in natural range 0 to 2**ADDR_WIDTH - 1;
        data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        we    : in std_logic;  -- Pas de valeur par défaut pour éviter l'activation d'écriture par défaut
        q     : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end DMEM;

architecture behav of DMEM is

    -- Définition de la mémoire comme un tableau de mots de DATA_WIDTH bits
    subtype word_t is std_logic_vector(DATA_WIDTH-1 downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Initialisation de la RAM
    function init_ram
        return memory_t is 
        variable tmp : memory_t := (others => (others => '0'));
    begin 
        tmp(0) := x"FFAABBCC";
        tmp(1) := x"11223344";
        tmp(2) := x"55667788";
        tmp(3) := x"00000000";
        tmp(4) := x"00000000";
        tmp(5) := x"00000000";
        tmp(6) := x"00000000";
        tmp(7) := x"00000000";
        return tmp;
    end init_ram;	 

    -- Signal interne pour stocker la mémoire DMEM avec valeurs initialisées
    signal DMEM : memory_t := init_ram;

begin

    -- Processus pour l'écriture synchrone
    process(clk)
    begin
        if rising_edge(clk) then
            -- Écriture synchrone lorsque `we` est actif
            if we = '1' then
                DMEM(addr) <= data;
            end if;
        end if;
    end process;

    -- Lecture asynchrone directement à partir de la mémoire
    q <= DMEM(addr);  -- Lecture asynchrone basée sur l'adresse

end behav;