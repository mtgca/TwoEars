function sim = setupBinauralSimulator()
%setupBinauralSimulator starts the Binaural SImulator and applies all common
%                       settings, like position of listener and length of
%                       simulation
%
%   USAGE
%       sim = setupBinauralSimulator()
%
%   OUTPUT PARAMETERS
%       sim  - Binaural Simulator object

% NOTE: the actual BRS (impulse responses) data set and the audio material
% will be set in the respective functions

sim = simulator.SimulatorConvexRoom();
set(sim, ...
    'BlockSize',            4096, ...
    'SampleRate',           44100, ...
    'NumberOfThreads',      1, ...
    'LengthOfSimulation',   1.5, ...
    'Renderer',             @ssr_brs, ...
    'Verbose',              false, ...
    'Sources',              {simulator.source.Point()}, ...
    'Sinks',                simulator.AudioSink(2) ...
    );
set(sim.Sinks, ...
    'Name',                 'Head' ...
    );
set(sim.Sources{1}, ...
    'AudioBuffer',          simulator.buffer.Ring(1) ...
    );
% set(sim.Sources{1}.AudioBuffer, ...
%     'File', 'sound_databases/grid_subset/s1/bbaf2n.wav' ...
%     );

sim.Sources{1}.AudioBuffer.loadFile( ...
  'sound_databases/grid_subset/s1/bbaf2n.wav', sim.SampleRate);

% vim: set sw=4 ts=4 et tw=90:
