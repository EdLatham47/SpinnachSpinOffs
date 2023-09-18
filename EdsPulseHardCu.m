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
inter.zeeman.eigs={[2.056, 2.056, 2.205];
                   [2.009, 2.006, 2.003]};
inter.zeeman.euler={[0 0 0]; [0 0 0]};
inter.coordinates={[0 0 0]; [20 0 0]};
inter.temperature = 10;
% inter.relaxation={'redfield','SRFK','SRSK'};


% g values
% t1 
% t2 
% j matrix
% euler angles. 


% Basis set
bas.formalism='zeeman-hilb';
bas.approximation = 'none';
%bas.approximation='IK-2';
%bas.connectivity='full_tensors';
%bas.space_level = 2;

% Disable trajectory level SSR algorithms
% sys.disable={'trajlevel'};
               
% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% Sequence parameters
parameters.spins={'E', 'E'};
parameters.rho0=state(spin_system,'Lz',[1 2]);
parameters.coil=state(spin_system,'Lz',[1 2]);
parameters.ex_prob = operator(spin_system,{'L+'},{1});
%parameters.ex_prob=(operator(spin_system,{'L+'},{1})+...
%                    operator(spin_system,{'L-'},{1}))/2;
parameters.ex_pump = operator(spin_system,{'L-'},{2});
parameters.ta=2e-7;
parameters.tb=1e-7;
parameters.t_last=1.5e-7; % 2.5
parameters.nsteps=256;
parameters.grid='rep_2ang_1600pts_sph';
parameters.orientation = [0 0 0]; % added to satisfy 'crystal' /powder

% Execute pulse sequence
echo=crystal(spin_system,@Eds_Hard_Echo,parameters,'esr');

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