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
        we    : in std_logic := '1';
        q     : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end DMEM;

architecture rtl of DMEM is

    -- Build a 2-D array type for the DMEM
    subtype word_t is std_logic_vector(DATA_WIDTH-1 downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Initialisation de la RAM
    function init_ram
        return memory_t is 
        variable tmp : memory_t := (others => (others => '0'));
    begin 
        tmp(0) := x"FFFFFFFF";
        tmp(1) := x"AAAAAAAA";
        tmp(2) := x"BBBBBBBB";
        tmp(3) := x"CCCCCCCC";
        tmp(4) := x"DDDDDDDD";
        tmp(5) := x"EEEEEEEE";
        tmp(6) := x"FAFAFAFA";
        tmp(7) := x"FBFBFBFB";
        return tmp;
    end init_ram;	 

    -- DMEM signal with initial values
    signal DMEM : memory_t := init_ram;

begin

    -- Asynchronous read and synchronous write process
    process(clk)
    begin
        if rising_edge(clk) then
            -- Synchronous write on rising edge of clock
            if we = '1' then
                DMEM(addr) <= data;
            end if;
        end if;
    end process;

    -- Asynchronous read directly from the memory
    q <= DMEM(addr);  -- Directly output data based on address

end rtl;
