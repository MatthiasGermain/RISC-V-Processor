library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_REG is
end entity tb_REG;

architecture behav of tb_REG is

    -- Composant du banc de registres
    component REG is
        port (
            clk          : in std_logic;
            Write_Enable : in std_logic;  -- Write enable
            RA, RB, RW   : in std_logic_vector(4 downto 0);  -- 5 bits pour sélectionner le registre
            BusW         : in std_logic_vector(31 downto 0);  -- Données à écrire
            BusA, BusB   : out std_logic_vector(31 downto 0)  -- Données en sortie
        );
    end component;

    signal clk_tb   : std_logic := '0';
    signal we_tb    : std_logic := '0';
    signal RA_tb, RB_tb, RW_tb : std_logic_vector(4 downto 0);
    signal BusW_tb  : std_logic_vector(31 downto 0);
    signal BusA_tb, BusB_tb : std_logic_vector(31 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instanciation du banc de registres
    uut : REG
        port map (
            clk          => clk_tb,
            Write_Enable => we_tb,
            RA           => RA_tb,
            RB           => RB_tb,
            RW           => RW_tb,
            BusW         => BusW_tb,
            BusA         => BusA_tb,
            BusB         => BusB_tb
        );

    -- Processus pour générer l'horloge
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Processus de test avec lecture et écriture dans les registres
    test_process : process
    begin
	 
	         -- Lecture des valeurs des registres
        for i in 0 to 31 loop
            RA_tb <= std_logic_vector(to_unsigned(i, 5));
            RB_tb <= std_logic_vector(to_unsigned(i, 5));
            wait for clk_period;

            -- Affichage des résultats
            report "BusA (registre " & integer'image(i) & ") = " & integer'image(to_integer(unsigned(BusA_tb)));
            report "BusB (registre " & integer'image(31 - i) & ") = " & integer'image(to_integer(unsigned(BusB_tb)));
        end loop;
		  
        -- Initialisation du test
        wait for 20 ns;
        
        -- Écriture dans les registres
        for i in 0 to 5 loop
            we_tb <= '1';  -- Activer l'écriture
            RW_tb <= std_logic_vector(to_unsigned(i, 5));  -- Sélectionner le registre à écrire
            BusW_tb <= std_logic_vector(to_unsigned(i + 5, 32));  -- Écrire une valeur (5 + index)
            wait for clk_period;
        end loop;
        we_tb <= '0';  -- Désactiver l'écriture
		  
		  for i in 0 to 8 loop
            RA_tb <= std_logic_vector(to_unsigned(i, 5));
            RB_tb <= std_logic_vector(to_unsigned(i, 5));
            wait for clk_period;

            -- Affichage des résultats
            report "BusA (registre " & integer'image(i) & ") = " & integer'image(to_integer(unsigned(BusA_tb)));
            report "BusB (registre " & integer'image(31 - i) & ") = " & integer'image(to_integer(unsigned(BusB_tb)));
        end loop;

        -- Fin de la simulation
        wait;
    end process;

end architecture behav;