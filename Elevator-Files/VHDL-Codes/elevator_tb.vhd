library ieee;
use ieee.std_logic_1164.all;

entity elevator_tb is end entity;

architecture behavior of elevator_tb is
 COMPONENT elevator
port (
		clk, rst    : in std_logic;
	    in_elev_key, out_elev_key    :  in  std_logic_vector(4 downto 1);
        AC 				: out std_logic_vector(1 downto 0);
		DISP			: out std_logic_vector(2 downto 0);
		is_open			: out std_logic
		);
 END COMPONENT;
	
	signal clk, rst    : std_logic := '1';
    signal in_elev_key, out_elev_key        : std_logic_vector(4 downto 1);
    signal AC      : std_logic_vector(1 downto 0);
	signal DISP	   : std_logic_vector(2 downto 0);
	signal is_open	: std_logic;
begin
uut: elevator
        port map (
		clk => clk, 
		rst => rst,
	    in_elev_key => in_elev_key, 
		out_elev_key => out_elev_key,
        AC => AC,
		DISP => DISP,
		is_open => is_open);

-- Process for generating the clock
    clk <= not clk after 10 ns;

    stim_proc: process
    begin
		wait for 40 ns;
		rst <= '0';
        in_elev_key <= "0100";
		out_elev_key <= "0000";
		wait for 40 ns;
        out_elev_key <= "1000";
		wait for 40 ns;
        in_elev_key <= "0010";
		out_elev_key <= "0000";
		wait for 20 ns;
		in_elev_key <= "0000";
		out_elev_key <= "0000";
		wait for 400 ns;
		rst <= '1';
        wait;
    end process;
end architecture;