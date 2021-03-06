function sim = setupBinauralSimulator()
%initialiseBinauralSimulator starts the Binaural SImulator and applies all common
%                            settings, like position of listener and length of
%                            simulation
%
%   USAGE
%       sim = initialiseBinauralSimulator()
%
%   OUTPUT PARAMETERS
%       sim  - Binaural Simulator object

% NOTE: the actual BRS (impulse responses) data set and the audio material
% changes during the simulation and will be set in the respective functions

sim = simulator.SimulatorConvexRoom();
set(sim, ...
    'BlockSize',            48000, ...
    'SampleRate',           48000, ...
    'NumberOfThreads',      1, ...
    'LengthOfSimulation',   5, ...
    'Renderer',             @ssr_brs, ...
    'Verbose',              false, ...
    'Sources',              {simulator.source.Point()}, ...
    'Sinks',                simulator.AudioSink(2) ...
    );
set(sim.Sinks, ...
    'Name',                 'Head', ...
    'UnitX',                [ 0.00 -1.00  0.00]', ...
    'UnitZ',                [ 0.00  0.00  1.00]', ...
    'Position',             [ 0.00  0.00  1.75]' ...
    );
set(sim.Sources{1}, ...
    'AudioBuffer',          simulator.buffer.FIFO(1) ...
    );

% vim: set sw=4 ts=4 et tw=90:
