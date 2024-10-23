library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMEM is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 5
    );
    port 
    (
        clk     : in std_logic;
        addr    : in natural range 0 to 2**ADDR_WIDTH - 1;
        q       : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
end entity;

architecture rtl of IMEM is

    -- Définir un tableau 2D pour la ROM
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Fonction pour initialiser la ROM
    function init_rom
        return memory_t is 
        variable tmp : memory_t := (others => (others => '0'));
    begin 
        -- Initialisation avec des valeurs arbitraires, chaque adresse reçoit une valeur sur 32 bits
        tmp(0) := x"000000FF";
        tmp(1) := x"000000AA";
        tmp(2) := x"000000BB";
        tmp(3) := x"000000CC";
        tmp(4) := x"000000DD";
        tmp(5) := x"000000EE";
        tmp(6) := x"000000FA";
        tmp(7) := x"000000FB";
        tmp(8) := x"000000FC";
        tmp(9) := x"000000FD";
        tmp(10) := x"000000FE";
        tmp(11) := x"000000AB";
        tmp(12) := x"000000AC";
        return tmp;
    end init_rom;    

    -- Signal pour stocker la ROM
    signal rom : memory_t := init_rom;

begin
    -- Processus pour lire dans la ROM
    process(addr)
    begin
        q <= rom(addr);  -- Lire la valeur de la ROM à l'adresse spécifiée
    end process;

end architecture rtl;
