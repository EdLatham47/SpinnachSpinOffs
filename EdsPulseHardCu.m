% Three-pulse DEER echo on a Cu(II)-NO two electron system at X-band.
% The calculation is done by brute-force time propagation and numerical
% powder averaging in Liouville space.
% Calculation time: seconds
% i.kuprov@soton.ac.uk
function EdsPulseHard()

% Spin system parameters
sys.magnet=0.33;
sys.isotopes={'E', 'E'};
sys.labels={'Electron1', 'Electron2'};

% ----------------------- INTERACTIONS -------------------------------
% _______________________   G VALUES   ________________________________
% Spatial Coupling alternative, NxN spins of 1x3 arrays. eigenbasis/diagonlaised. 
inter.zeeman.eigs={[2.003 2.003 2.003];
                   [2.007 2.007 2.007]};
inter.zeeman.euler={[0 0 0]; [0 0 0]};
% inter.zeeman.matrix={ [5 0 0; 0 5 0; 0 0 5] ...
%                      [5 0 0; 0 5 0; 0 0 5] ...
%                      [2.0023 0 0; 0 2.0025 0; 0 0 2.0027]};
% inter.coordinates={[0 0 0]; [20 0 0]};

% _______________________   J COUPLING   ________________________________
% Isotropic couplings (in Hz). Individual cells in the array may be left empty, in which case zeros are assumed.
inter.coupling.scalar={0 30*10^6; 0 0};

% ---------------------- RELAXATION -----------------------
% Longitudinal and transverse relaxation rates (not times) in Hz should be provided for each spin. 
% Liouville space spherical tensor formalism.
%inter.relaxation={'t1_t2'};
%inter.r1_rates=[1.0 2.0 5.0];  
%inter.r2_rates=[5.0 7.0 9.0];

% Basis set
bas.formalism='sphten-liouv';
bas.approximation = 'none';
% Temeperature
inter.temperature = 2; % Kelvin.

%bas.formalism='zeeman-hilb';
%bas.approximation='IK-2';
%bas.connectivity='full_tensors';
%bas.space_level = 2;

% Disable trajectory level SSR algorithms
% sys.disable={'trajlevel'};
               
% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);
R = relaxation(spin_system, inter.zeeman.euler);

% Sequence parameters
parameters.spins={'E', 'E'};
parameters.rho0=state(spin_system,{'L+','L+'}, {1,2});
parameters.coil=[state(spin_system,{'L+'}, {2})...
                    state(spin_system,{'L+'}, {2})];
% Rot around X
parameters.ex_prob=(operator(spin_system,{'L+'},{1})+...
                    operator(spin_system,{'L-'},{1}))/2;
% Rot around Y. - not used atm but satisfies grumpy Spinach 'grumble'
parameters.ex_pump=(operator(spin_system,{'L+'},{1})-...
                    operator(spin_system,{'L-'},{1}))/2;
parameters.ta=2e-7;
parameters.tb=1e-7;


% Pulse sequence parameters
parameters.t_last=2.5e-7; % 2.5 last time point
parameters.J=inter.coupling.scalar;
parameters.mw_pwr=3;
parameters.npoints=1;
parameters.mw_freq=9.4*10^9;

parameters.nsteps=256;
parameters.grid='rep_2ang_1600pts_sph';
parameters.orientation = [0 0 0]; % added to satisfy 'crystal' /powder

% Execute pulse sequence
echo=powder(spin_system,@Eds_Hard_Echo, parameters,'esr');

% P=sphten2zeeman(spin_system);
% zeeman_rho=P*echo;

% Build the time axis
time_axis=linspace(-parameters.t_last/2,...
                   +parameters.t_last/2,parameters.nsteps+1);

% Plotting
figure(); plot(1e6*time_axis,imag(echo)); kgrid;
xlabel('time, microseconds'); axis tight;
ylabel('Magnetisation');
end