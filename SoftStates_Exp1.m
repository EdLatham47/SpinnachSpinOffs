% Three-pulse DEER simulation for a two-electron system. Soft 
% pulses are simulated using the Fokker-Planck formalism.
%
% Calculation time: minutes
%
% i.kuprov@soton.ac.uk

function SoftStates_Exp1()

    % Magnet field
    sys.magnet=0.3451805;
    
    % Isotopes
    sys.isotopes={'E','E'};
    ,,
    % Zeeman interactions
    inter.zeeman.eigs=cell(1,2);
    inter.zeeman.euler=cell(1,2);
    inter.zeeman.eigs{1}=[2.003 2.003 2.003];
    inter.zeeman.euler{1}=[0 0 0]*(pi/180);
    inter.zeeman.eigs{2}=[2.007 2.007 2.007];
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
    parameters.rho0=state(spin_system,{'L+','L+'} ,{1,2});
    parameters.coil=state(spin_system,{'L+'},{2});
    parameters.grid='rep_2ang_6400pts_sph';
    parameters.method='expm';
    parameters.verbose=0;
    
    % EPR parameters
    parameters.offset=-4e8;
    parameters.sweep=3e9;
    parameters.npoints=256;
    parameters.zerofill=2048;
    parameters.axis_units='GHz-labframe';
    parameters.derivative=0;
    parameters.invert_axis=1;
    parameters.assumptions='esr';
    
    % DEER pulse parameters
    parameters.pulse_rnk=[2 2 2];
    parameters.pulse_dur=[30e-9];
    parameters.pulse_phi=[pi];
    parameters.pulse_pwr=2*pi*[8e6 8e6 8e6];
    parameters.pulse_frq=[9.4e9];
    
    % DEER echo timing parameters
    parameters.p1_echo_gap=1e-6;

    parameters.p1_p3_gap=1e-6;
    parameters.p2_nsteps=100;
    parameters.echo_time=100e-9;
    parameters.echo_npts=100;
    % Wrap thesse inputs, to then see a T2 time. 
    
    % Simulation and plotting
    SoftStates_Pulses2(spin_system,parameters);
    
    end