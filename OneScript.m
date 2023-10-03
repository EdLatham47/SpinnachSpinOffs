%all of the three pulse deer written by me into one script. 

function OneScript()
    % System Specifications. 
    sys.magnet = 0.3451805; %T
    % SPins to be viewed.
    sys.isotopes = {'E','E'}; %Two seperated electrons, as oppose to two in one shell (E2)
    sys.disable={'trajlevel'}; % (For less than five spins, speeds up computation.)

    %           SPIN INTERACTIONS
    % defines structure of spins. 
    inter.zeeman.eigs = cell(1,2);
    inter.zeeman.euler = cell(1,2);
    inter.coordinates = cell(1,2);
    % First Spin g-values then euler angle relative to B0.
    inter.zeeman.eigs{1}=[2.0034 2.0031 2.0027];
    inter.zeeman.euler{1}=[0 0 0];
    inter.coordinates{1}=[0 0 0];
    % Second Spin g-values then euler angle relative to B0.
    inter.zeeman.eigs{2}=[2.005 2.007 2.009];
    inter.zeeman.euler{2}=[0 0 0];
    inter.coordinates{2}=[1.5 0 0]; % Angstrungs
    % - Relaxation
    inter.relaxation={'lindblad'};
    inter.lind_r1_rates=[1.0 1.0]; % Hz
    inter.lind_r2_rates=[1.0 1.0]*10^5; % Hz
    inter.temperature=2; %Kelvin. Default: Spinach uses the high-temperature approximation. 
                        % Specifying zero makes the system start at the lowest energy eigenstate of the Hamiltonian.
    inter.rlx_keep='diagonal';%Not sure what these do..... will require further investigation.
    inter.equilibrium='zero';
    % inter.coupling.scalar = {0 30*10^6; 0 0}; % Off diags are coupling strengths in Hz.
    
    %Create Spin System using the specifications above. (Before experimental parameters.)
    spin_system=create(sys,inter);
    % Basis Set
    bas.formalism = 'sphten-liouv';
    bas.approximation = 'none';
    %rotate spin sys into basis.
    spin_system=basis(spin_system,bas);

    %           COMPUTATIONAL PARAMETERS
    % spherical averaging grid for solid state experiments
    parameters.grid='rep_2ang_6400pts_sph'; % ~./spinnach_2_7_6049/kernel/grids
    % MEthod. soft puse propagation method,'expv' for Krylov propagation,'expm' for exponential propagation, 'evolution' for Spinach evolution function
    parameters.method='expm';
    % Fidelity of the pulse. (Keep in 2^n for ease of computation.)
    parameters.npoints = 256;
    % zerofill - Fidelity of Free Induction Decay Plots. (First Figure) 
    parameters.zerofill = 2048;
    parameters.axis_units = 'GHz-labframe';
    % if set to 1, the spectrum is differentiated before plotting
    parameters.derivative=1;
    % if set to 1, the spectrum is multiplied by -1 before plotting (Left to right right to left for the Hz)
    parameters.invert_axis=1; 
    % As oppose to nmr, 
    parameters.assumptions='esr';
    %STFU
    parameters.verbose=0;
    
%gaussleg.m for magic stuff to do with linewidth calculating.
    % linewidth 0.1 20 gauss 0.002Tesla +/-1gauss 


    %           EXPERIMENTAL PARAMETERS
    parameters.spins = {'E'}; % spins of the molecule that will be activlley operated on.
    % a combined initial state of both spins, alligned in the Bz direction. 
    parameters.rho0=state(spin_system,{'Lz','Lz'}, {1,2});
    % detection state of the output files. (pi/2 tf L+), can add more than one detection state.
    parameters.coil = state(spin_system,'L+',1);
    % offset - the offset of the pulse from the center of the pulse.
    parameters.offset = -4e8;   % taken from 2e example.
    % Sweep width in each dimension of the spectrum (Hz).
    parameters.sweep = 3e9;     %taken from 2e example
    % Linewidth?
    parameters.fwhm=0.001;          
    %       THE INDIVIDUAL PULSES
    % DEER pulse parameters - all params can be lists for multi-pulse sequences. 
    %pulse_rnk 1 would be a perfect pulse. 2 does narruto change. 3 will aid in more complex-multi rotations. 
    parameters.pulse_rnk=[2 2 2];
    % Pulse duration
    parameters.pulse_dur=[20e-9 40e-9 40e-9];       % altered 30ns suggestion
    % Phase on initial wave
    parameters.pulse_phi=[pi/2 pi/2 pi/2];
    % Power of the pulse
    parameters.pulse_pwr=2*pi*[8e6 8e6 8e6];
    % Frequency of the pulse - independantly specified is a bit odd.
    parameters.pulse_frq=[9.4e9 34e9 9.4e9];
    %        GAPS BETWEEN PULSES
    parameters.p1_p3_gap=1e-6;
    %fidelity of p2
    parameters.p2_nsteps=100;
    % readout gap for echo
    parameters.echo_time=100e-9;
    % pfidelity of echo
    parameters.echo_nsteps=100;
    %           SIMULATION
    % End of inputs, begin simulation. 
    OneScript_Plots(spin_system, parameters)
    end