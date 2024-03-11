%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Engin Subasi
% enginsubasi@gmail.com
% github.com/enginsubasi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

text = fileread ( 'Attack_free_dataset_10k.txt' );

textLines = splitlines ( text );

timeStampArr = zeros ( size ( textLines, 1 ), 1 );
idArr = zeros ( size ( textLines, 1 ), 1 );
rdrArr = zeros ( size ( textLines, 1 ), 1 );
dlc = zeros ( size ( textLines, 1 ), 1 );
datafield = zeros ( size ( textLines, 1 ), 8 );
hexString = " ";

for i = 1 : 1 : size ( textLines, 1 )

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

uniqueIDs = unique ( idArr );
uniqueIDsCount = histcounts ( idArr, length ( uniqueIDs ) )';

