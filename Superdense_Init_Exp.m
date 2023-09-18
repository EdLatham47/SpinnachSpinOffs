% Three-pulse DEER echo on a Cu(II)-NO two electron system at X-band.
% The calculation is done by brute-force time propagation and numerical
% powder averaging in Liouville space.
% Calculation time: seconds
% i.kuprov@soton.ac.uk

function Superdense_Init_Exp()

% Spin system parameters
sys.magnet=0.33;
sys.isotopes={'E4'};
inter.temperature=80;
%Check spin.m file
%sys.labels = {'00','01','10','11'};

%Needs discovering
inter.zeeman.matrix = {[2.0023 0 0; 0 2.0025 0; 0 0 2.0027]};
%inter.zeeman.scalar={2.0023 1.0 2.0 3.0};
%inter.zeeman.euler={[0 0 0]; [0 0 0]};
%inter.coordinates={[0 0 0]; [200 0 0]};

% Basis set
bas.formalism='sphten-liouv';
bas.approximation='none';

% Disable trajectory level SSR algorithms
sys.disable={'trajlevel'};
               
% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% Sequence parameters
%correct states with state.m for all 4 electron spins.
parameters.rho0=state(spin_system,'Lz','E4');
parameters.coil=state(spin_system,'L+','E4');


parameters.ex_pump=(operator(spin_system,{'L+'},{1})+...
                    operator(spin_system,{'L-'},{1}))/2;
parameters.ex_prob=(operator(spin_system,{'L+'},{1})+...
                    operator(spin_system,{'L-'},{1}))/2;
parameters.spins={'E4'};

% loads of new timings needed. 
parameters.ta=2e-7;
parameters.tb=1e-7;
parameters.tc=2.5e-8;
parameters.nsteps=256;
parameters.grid='rep_2ang_1600pts_sph';
parameters.orientation = [0 0 0]; % added to satisfy 'crystal' /powder

% Pulse sequence
echo=crystal(spin_system,@Eds_Hard_Echo,parameters,'esr');
% Assumption 'esr' Rotating frame approximation for electrons; 
% laboratory frame simulation for nuclei; 
% secular terms for electron Zeeman interactions;
% all terms for nuclear Zeeman interactions;
% secular terms for inter-electron couplings; 
% secular terms for electron zero-field splittings;
% secular terms for giant spin model interactions; 
% secular and pseudosecular terms for hyperfine couplings; 
% all terms for inter-nuclear couplings; 
% all terms for nuclear quadrupolar couplings.


% Build the time axis
time_axis=linspace(-parameters.tc/2,...
                   +parameters.tc/2,parameters.nsteps+1);

% Plotting
figure(); plot(1e6*time_axis,imag(echo)); kgrid;
xlabel('time, microseconds'); axis tight;

end