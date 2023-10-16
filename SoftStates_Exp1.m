% Three-pulse DEER simulation for a two-electron system. Soft 
% pulses are simulated using the Fokker-Planck formalism.
%
% Write out pulse sequence specifics. 

function SoftStates_Exp1()

    % Magnet field
    sys.magnet=0.333333;
    
    % Isotopes
    sys.isotopes={'E','E'};
    % Zeeman interactions
    inter.zeeman.eigs=cell(1,2);
    inter.zeeman.euler=cell(1,2);
    inter.zeeman.eigs{1}=[2.0027 2.0029 2.0031];
    inter.zeeman.euler{1}=[0 0 0]*(pi/180);
    inter.zeeman.eigs{2}=[2.0027 2.0029 2.0031];
    inter.zeeman.euler{2}=[0 0 0]*(pi/180);
    
    % Coordinates (Angstrom)
    %inter.coordinates=cell(2,1);
    %inter.coordinates{1}=[0.00  0.00 0.00];
    %inter.coordinates{2}=[20.00 0.00 0.00];

    % Hyperfine interactions (Hz)
    inter.coupling.scalar={0 30*10^6; 0 0};

    % Basis set
    bas.formalism='sphten-liouv';
    bas.approximation='none';
    
    % Algorithmic options
    sys.disable={'trajlevel'};
    
    % Spinach housekeeping
    spin_system=create(sys,inter);
    spin_system=basis(spin_system,bas);
    
    % Sequence parameters
    parameters.spins={'E'};
    parameters.rho0=state(spin_system,{'Lz','Lz'} ,{1,2});
    parameters.coil=state(spin_system,{'L+'},{2});
    parameters.grid='rep_2ang_6400pts_sph';
    parameters.method='expm';
    parameters.verbose=0;
    
    % EPR parameters
    parameters.offset=10e8;
    parameters.sweep=3e9;
    
    % npoibnts divides the time step of evolution. 
    parameters.npoints=256;
    parameters.zerofill=2048;
    parameters.axis_units='GHz-labframe';
    parameters.derivative=1;
    parameters.invert_axis=1;
    parameters.assumptions='deer-zz';
    
    % DEER pulse parameters - all params can be lists for multi-pulse sequences. 
    %pulse_rnk 1 would be a perfect pulse. 2 does narruto change. 3 will aid in more complex-multi rotations. 
    parameters.pulse_rnk=[2 2 2];
    % Pulse duration
    parameters.pulse_dur=[15e-9 30e-9 30e-9];
    % Phase on initial wave
    parameters.pulse_phi=[pi pi pi];
    % Power of the pulse
    parameters.pulse_pwr=2*pi*[8e6 8e6 8e6];
    % Frequency of the pulse - independantly specified is a bit odd.
    parameters.pulse_frq=[9.4e9 34e9 9.4e9];
    

    % DEER echo timing parameters
    parameters.p1_echo_gap=1e-6;
    % Linewidth?
    parameters.fwhm=0.001;
    % same spin gap.
    parameters.p1_p3_gap=1e-6;
    % splits the pulse into that many steps for modelling (timeframe/nsteps). 
    parameters.p2_nsteps=100;
    %location of the echo.
    parameters.echo_time=1e-6; %100e-9;
    %split echo into steps, for greater clarity, increase.
    parameters.echo_npts=1000;

    % Wrap thesse inputs, to then see a T2 time. 
    % Simulation and plotting
    P = sphten2zeeman(spin_system);
    Happiness=P*parameters.rho0
    stateinfo(spin_system, Happiness, 4)

    SoftStates_Plots2(spin_system,parameters);

    P = sphten2zeeman(spin_system);
    Happiness=P*parameters.rho0
    stateinfo(spin_system, Happiness, 4)
    end