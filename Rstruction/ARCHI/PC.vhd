library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    generic (
        N : integer := 32  -- Taille du compteur de programme (PC)
    );
    port (
        clk          : in  std_logic;                       -- Horloge
        reset        : in  std_logic;                       -- Signal de reset
        load         : in  std_logic;                       -- Signal pour charger une nouvelle adresse
        Write_Enable : in  std_logic;                       -- Activation de l'écriture dans le PC
        Data_In      : in  std_logic_vector(N-1 downto 0);  -- Nouvelle valeur du PC (si load = '1')
        Data_Out     : out std_logic_vector(N-1 downto 0)   -- Valeur actuelle du PC
    );
end entity PC;

architecture Behavioral of PC is
    signal pc_value : std_logic_vector(N-1 downto 0) := (others => '0');  -- Valeur interne du PC

begin
    -- Processus de gestion du compteur de programme
    process (clk, reset)
    begin
        if reset = '1' then
            -- Si le reset est activé, on remet le PC à zéro
            pc_value <= (others => '0');
        elsif rising_edge(clk) then
            if Write_Enable = '1' then
                if load = '1' then
                    -- Charger une nouvelle valeur dans le PC si 'load' est actif
                    pc_value <= Data_In;
                else
                    -- Sinon, incrémenter le PC de 1 au lieu de 4
                    pc_value <= std_logic_vector(unsigned(pc_value) + 1);
                end if;
            end if;
        end if;
    end process;

    -- Sortie de la valeur actuelle du PC
    Data_Out <= pc_value;

end architecture Behavioral;
