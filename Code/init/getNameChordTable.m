function chordTable = getNameChordTable(Path)
% GETNAMECHORDTABLE From path, it assumes jimchord2012 structure

% extract paths
guitarPath = [Path,'/Guitar_Only/'];
otherPath = [Path,'/Other_Instruments/'];

oi = dir(otherPath);
instruments = {oi(3:end).name};

otherPaths = strcat(otherPath,instruments,'/');

% extract paths
[Path,Chord] = extractPathChord(guitarPath);
chordTable = table(Path',Chord');

for i = 1:length(otherPaths)
    [Path,Chord] = extractPathChord(otherPaths{i});
    chordTable = [chordTable;...
        table(Path',Chord')];
end

% setup table
chordTable.Properties.VariableNames = {'Path','Chord'};
chordTable.Chord = categorical(chordTable.Chord);

end

%% utility

function [paths,chords] = extractPathChord(path)
% assumes jimchord2012 structure
chordPaths = dir(path);
chordPaths(1:2) = [];

% paths and chords extraction
paths = {};
chords = {};

for i = 1:length(chordPaths)
    newChordName = chordPaths(i).name;
    newPath = [path,newChordName,'/'];
    fileList = dir(newPath);
    
    % path extraction
    fileNames = {fileList(3:end).name};
    paths = [paths, strcat(newPath,fileNames)];
    
    % chord extraction
    chordName = [upper(newChordName(1)), newChordName(2:end)];
    chords = [chords, repmat( {chordName},1,length(fileNames) )];
end

end