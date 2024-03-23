%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Engin Subasi
% enginsubasi@gmail.com
% github.com/enginsubasi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

% File text
text = fileread ( 'Attack_free_dataset_10k.txt' );

% Lines of the text
textLines = splitlines ( text );

sampleCount = size ( textLines, 1 );
% Manual limit
sampleCount = 1000; 

% Data fields to store in MATLAB
timeStampArr = zeros ( sampleCount, 1 );
idArr = zeros ( sampleCount, 1 );
rdrArr = zeros ( sampleCount, 1 );
dlc = zeros ( sampleCount, 1 );
datafield = zeros ( sampleCount, 8 );
hexString = " ";

% Main loop for collecting data from file to MATLAB
for i = 1 : 1 : sampleCount

    str = string ( textLines ( i ) );

    newStr = extractBetween ( str, "Timestamp:", "ID" );
    timeStamp = str2double ( newStr );
    timeStampArr ( i ) = timeStamp;

    newStr = extractBetween ( str, "ID:", "DLC:" );
    newStr = regexprep ( newStr, '(.)(?=.)\t', '$1' );
    newStr = strtrim ( newStr );
    idrdr = strsplit ( newStr, ' ' );
    
    idArr ( i ) = hex2dec ( idrdr ( 1 ) );
    if hex2dec ( idrdr ( 2 ) ) ~= 0
        rdrArr ( i ) = 1;
    end

    newStr = extractAfter ( str, "DLC: " );
    newStr = extract ( newStr, 1 );
    dlc ( i ) = str2double ( newStr );

    hexString = strtrim ( extractAfter ( extractAfter ( str, "DLC: " ), num2str ( dlc ( i ) ) ) );
    % Split the string into individual hex values
    hexValues = strsplit ( hexString, ' ' );
    
    % Convert each hex value to decimal
    decimalValues = hex2dec ( hexValues );

    for j = 1 : 1 : 8
        
        if j <= dlc ( i )
            datafield ( i, j ) = decimalValues ( j );
        else
            datafield ( i, j ) = 0;
        end

    end
end

% To find unique message ids in the network
uniqueIDs = unique ( idArr );
uniqueIDsCount = histcounts ( idArr, length ( uniqueIDs ) )';

% Generate a generic structure to analyze scripts in vehnet library
s = struct ( 'ts', timeStampArr, 'id', idArr, 'rdr', rdrArr, 'dlc', dlc, 'data', datafield, 'idlist', uniqueIDs );

% Show each data in seperated figures
for i = 1 : 1 : size ( s.idlist, 1 )

    figure;
    title ( i );

    [ rts, rdata ] = getMessageByIndex ( s, i );
    plot ( rts, rdata );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function definition section
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ms, data ] = getMessageByIndex ( s, msgidindex )

    j = 1;
    ms = zeros ( 1, 1 );
    data = zeros ( 1, 1 );

    for i = 1 : 1 : size ( s.ts )
        if ( s.id ( i ) == s.idlist ( msgidindex ) )
            ms ( j ) = s.ts ( i );
            for k = 1 : 1 : size ( s.data, 2 )
                data ( j, k ) = s.data ( i, k );
            end
            
            j = j + 1;
        end
    end
end
