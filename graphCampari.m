%========================================================================== 
%
%                               graphCampari
%
%                 A basic output grapher for Campari data
%
%
%       The file to be input should only have one Analysis Group # 
%         (Only the first row should have a non-numerical label)
%
%   Ian Harvey
%   Pappu Lab
%   May 2014
%==========================================================================

function graphCampari(inDir)
    display('Starting to graph raw CAMPARI data');
    % Directory formatting
    cd(inDir);
    outDir = 'parsedOutput_NOBKP/';
    
    % Determine if the graphs have already been made.
    boolGraph = false;
    gotInput = false;
    if exist(outDir,'dir')>0
       display('This Campari data appears to have been parsed already.');
       while ~gotInput
           qu = input('Do you want to overwrite? (y/n): ','s');
           switch qu(1)
               case 'y'
                   boolGraph = true;
                   gotInput = true;
               case 'Y'
                   boolGraph = true;
                   gotInput = true;
               case 'n'
                   gotInput = true;
               case 'N'
                   gotInput = true;
               otherwise
                   display('Could not interpret your input.');
           end
       end
    else
        boolGraph = true;
    end
    
    % If the graphs don't appear to have been already made, graph them!
    if boolGraph
        % If the directory doesn't already exist
        if ~gotInput
            mkdir(outDir);
            mkdir(strcat(outDir,'matlab'));
        end
        
        outDir = strcat(outDir,'matlab/');
        
        % Start generating the graphs into the parsedOutput directory
        % Process POLYMER
        query = 'POLYMER';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 1, 'Simulation Step Number');
        end
        
        % Process RETEHIST
        query = 'RETEHIST';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 2, 'End-to-End Distances (Å)', 'Probability(dist)', 'Probability Distribution of End-to-End Distances');
        end

        % Process RGHIST
        query = 'RGHIST';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 2, 'Radii of Gyration (Å)', 'Probability(dist)', 'Probability Distribution of Radii of Gyration');
        end

        % Process RDHIST
        query = 'RDHIST';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 3, 'Normalized Radius of Gyration (Parameter t)', 'Asphericity δ*', 'Parameter t vs Asphericity');
        end

        % Process DENSPROF
        query = 'DENSPROF';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 5, 'Log(Distance from the center of mass', 'Average chain density (g/cm^3)', 'Average Protein Density Distribution');
        end

        % Process RAMACHANDRAN
        query = 'RAMACHANDRAN';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 6, 'Phi (Degrees)', 'Psi (Degrees)', 'Ensemble Torsion Angle Favorability');
        end

        % Process MOLRAMA_00001
        query = 'MOLRAMA_00001';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 6, 'Phi (Degrees)', 'Psi (Degrees)', 'Initial Torsion Angle Favorability');
        end

        % Process BB_SEGMENTS
        query = 'BB_SEGMENTS';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 7, 'Longest Polypeptide Segment Observed Per Peptide Analyzed');
        end

        % Process BB_SEGMENTS_NORM
        query = 'BB_SEGMENTS_NORM';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 7, 'Longest Polypeptide Segment Observed Per Peptide Analyzed');
        end

        % Process BB_SEGMENTS
        query = 'BB_SEGMENTS_RES';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 8, 'Analysis Group Number');
        end

        % Process BB_SEGMENTS_NORM
        query = 'BB_SEGMENTS_NORM_RES';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 8, 'Analysis Group Number');
        end
        
        % Process DSSP_RES
        query = 'DSSP_RES';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 9, 'Residue Number');
        end
        
        % Process DSSP_NORM_RES
        query = 'DSSP_NORM_RES';
        if exist(strcat(query,'.dat'),'file')>0
            oneGraph(strcat(inDir,strcat(query,'.dat')), strcat(outDir, 'm',query), 9, 'Residue Number');
        end
        
        % Process DSSP
        
        % !!!!!!!!!!!!!!!!!!!!!!!Continue Here!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
    end
    display('Finished graphing raw CAMPARI data');
    % Close after finishing
    exit
end

function labelAndSave(afig, xL, yL, tL, outfile)
    xlabel(xL);
    ylabel(yL);
    title(tL);
    saveas(afig, outfile, 'png');
end

function oneGraph(infile, outfile, fmt, xL, yL, tL)

    % Set k as the default values if 6-k arguments were given
    if nargin < 6
        tL = '';
        if nargin < 5
            yL = 'Y value';
            if nargin < 4
               xL = 'X value';
               if nargin < 3
                  % Try to just plot the data
                  fmt = 4;
                  if nargin < 2
                     outfile = 'output';
                     if nargin < 1
                         display('[FATAL ERROR]: No input file argument detected.');
                         return;
                     end
                  end
               end
            end
        end
    end
    
    afig = figure('visible','off');
    % Caveat: If you tweak the line below, you should respectively tweak
    % picNextSlide()'s declaration of gWidth in ooi.py
    set(afig, 'Position', [100,100,6400,4300]);
    % fmt Configuration:
    % 1: plot - POLYMER
    % 2: bar - RETEHIST, RGHIST
    % 3: contour - RDHIST
    switch fmt
        % Only for POLYMER.dat, yL and tL have no meaning
        % TODO: Put in titles for each polymer graph!!!!!!!!!!!!!!!!!!!!!!!
        case 1
            A = importdata(infile,' ',1);
            plot(A.data(:,1),A.data(:,2));
            labelAndSave(afig, xL, 'Radius of Gyration (Å)', tL, strcat(outfile, '_1_2'));
            plot(A.data(:,1),A.data(:,3));
            labelAndSave(afig, xL, 'Parameter t', tL, strcat(outfile, '_1_3'));
            plot(A.data(:,1),A.data(:,4));
            labelAndSave(afig, xL, 'Asphericity', tL, strcat(outfile, '_1_4'));
            plot(A.data(:,1),A.data(:,5));
            labelAndSave(afig, xL, 'Acylindricity', tL, strcat(outfile, '_1_5'));
            plot(A.data(:,1),A.data(:,6));
            labelAndSave(afig, xL, 'δinst', tL, strcat(outfile, '_1_6'));
            plot(A.data(:,1),A.data(:,7));
            labelAndSave(afig, xL, 'λ1 Eigenvalue of Gyration Tensor (Å^2)', tL, strcat(outfile, '_1_7'));
            plot(A.data(:,1),A.data(:,8));
            labelAndSave(afig, xL, 'λ2 Eigenvalue of Gyration Tensor (Å^2)', tL, strcat(outfile, '_1_8'));
            plot(A.data(:,1),A.data(:,9));
            labelAndSave(afig, xL, 'λ3 Eigenvalue of Gyration Tensor (Å^2)', tL, strcat(outfile, '_1_9'));
        % Generalized bar graph function
        case 2
            A = importdata(infile,' ',1);
            bar(A.data(:,1),A.data(:,2));
            labelAndSave(afig, xL, yL, tL, outfile);
        
        % Only for RDHist.dat
        case 3
            A = importdata(infile,' ',1);
            contour(A.data);
            % Redefine the labels from 0:100 to 0:1
            set(gca, 'yticklabel',.1:.1:1);
            set(gca, 'xticklabel',.1:.1:1);
            labelAndSave(afig, xL, yL, tL, outfile);
        case 4
            A = importdata(infile,' ',1);
            plot(A.data);
            labelAndSave(afig, xL, yL, tL, outfile);
        % LogPlot wrt the first column: DENSPROF
        case 5
            A = importdata(infile,' ',1);
            plot(log(A.data(:,1)),A.data(:,2));
            labelAndSave(afig, xL, yL, tL, outfile);
        case 6
            A = importdata(infile);
            surf(log(A),'EdgeColor','none');
            axis([0,60,0,60]);
            set(gca, 'yticklabel',-180:60:180);
            set(gca, 'xticklabel',-180:60:180);
            labelAndSave(afig, xL, yL, tL, outfile);
        % Only for BB_SEGMENTS +/- _NORM
        case 7
            A = importdata(infile,' ',1);
            % Determines if normalize or not
            % Type of graph defined below the if-statement
            if isempty(strfind(infile,'NORM'))
                yL = 'Number of Peptides';
                tL = 'Histogram of Peptides'; 
            else
                yL = 'Propensity of Peptides';
                tL = 'Normalized Propensities of Peptides';
            end
            bar(1:length(A.data),A.data(:,1));
            labelAndSave(afig, xL, {yL, 'Beta'}, {tL,'Beta State'}, strcat(outfile, '_1'));
            bar(1:length(A.data),A.data(:,2));
            labelAndSave(afig, xL, {yL,'PII (Polyproline Type II Helix)'}, {tL,'PII State'}, strcat(outfile, '_2'));
            bar(1:length(A.data),A.data(:,3));
            labelAndSave(afig, xL, {yL,'Unusual Region ("Pass")'}, {tL,'Unusual Region'}, strcat(outfile, '_3'));
            bar(1:length(A.data),A.data(:,4));
            labelAndSave(afig, xL, {yL,'Alpha(R) (Right-Handed Alpha Helix)'}, {tL,'Alpha(R) State'}, strcat(outfile, '_4'));
            bar(1:length(A.data),A.data(:,5));
            labelAndSave(afig, xL, {yL,'Inverse C7 Equatorial (Gamma''-turn)'}, {tL,'Gamma''-turn State'}, strcat(outfile, '_5'));
            bar(1:length(A.data),A.data(:,6));
            labelAndSave(afig, xL, {yL,'Classic C7 Equatorial (Gamma-turn)'}, {tL,'Gamma-turn State'}, strcat(outfile, '_6'));
            bar(1:length(A.data),A.data(:,7));
            labelAndSave(afig, xL, {yL,'Unusual Region (Helix with 7 Residues per Turn)'}, {tL,'Unusual (7 Residue Helix) Region'}, strcat(outfile, '_7'));
            bar(1:length(A.data),A.data(:,8));
            labelAndSave(afig, xL, {yL,'Alpha(L) (Left-Handed Alpha Helix)'}, {tL,'Alpha(L) State'}, strcat(outfile, '_8'));
        % Only for BB_SEGMENTS_RES +/- _NORM
        case 8
            A = importdata(infile,' ',1);
            % Determines if normalize or not
            % Type of graph defined below the if-statement
            if isempty(strfind(infile,'NORM'))
                yL = 'Number of Residues in ';
                tL = 'Histogram of Residues in the '; 
            else
                yL = 'Propensity of Residues in ';
                tL = 'Normalized Propensities of Residues in the ';
            end
            
            % Plot each graph regarding per residue backbone character
            plotBBRes(A, 1, 8);
            labelAndSave(afig, xL, {yL, 'Beta'}, {tL,'Beta State'}, strcat(outfile, '_1'));
            plotBBRes(A, 2, 8);
            labelAndSave(afig, xL, {yL,'PII (Polyproline Type II Helix)'}, {tL,'PII State'}, strcat(outfile, '_2'));
            plotBBRes(A, 3, 8);
            labelAndSave(afig, xL, {yL,'Unusual Region ("Pass")'}, {tL,'Unusual Region'}, strcat(outfile, '_3'));
            plotBBRes(A, 4, 8);
            labelAndSave(afig, xL, {yL,'Alpha(R) (Right-Handed Alpha Helix)'}, {tL,'Alpha(R) State'}, strcat(outfile, '_4'));
            plotBBRes(A, 5, 8);
            labelAndSave(afig, xL, {yL,'Inverse C7 Equatorial (Gamma''-turn)'}, {tL,'Gamma''-turn State'}, strcat(outfile, '_5'));
            plotBBRes(A, 6, 8);
            labelAndSave(afig, xL, {yL,'Classic C7 Equatorial (Gamma-turn)'}, {tL,'Gamma-turn State'}, strcat(outfile, '_6'));
            plotBBRes(A, 7, 8);
            labelAndSave(afig, xL, {yL,'Unusual Region (Helix with 7 Residues per Turn)'}, {tL,'Unusual (7 Residue Helix) Region'}, strcat(outfile, '_7'));
            plotBBRes(A, 8, 8);
            labelAndSave(afig, xL, {yL,'Alpha(L) (Left-Handed Alpha Helix)'}, {tL,'Alpha(L) State'}, strcat(outfile, '_8'));
        % Only for DSSP_RES +/- _NORM
        case 9
            % Reformat so that plotBBRes functions correctly
            T.data = importdata(infile,' ');
            
            % Determines if normalized or not and defines accordingly
            if isempty(strfind(infile,'NORM'))
                yL = 'Number of Occurences of Residue';
                tL = 'Histogram of Residues';
            else
                yL = 'Propensity of Occurence of Residue';
                tL = 'Normalized Propensities of Residues';
            end
            
            % Plot each graph (for separate DSSP characteristics)
            plotBBRes(T, 1, 11);
            labelAndSave(afig, xL, {yL, 'an Extended Parallel Beta-strand with 1 Partner (E)'}, ...
                {tL, 'Extended Parallel Beta w/ 1 Partner'}, strcat(outfile, '_1'));
            plotBBRes(T, 2, 11);
            labelAndSave(afig, xL, {yL, 'an Extended Anti-Parallel Beta-strand with 1 Partner (E)'}, ...
                {tL, 'Extended Anti-Parallel Beta w/ 1 Partner'}, strcat(outfile, '_2'));
            plotBBRes(T, 3, 11);
            labelAndSave(afig, xL, {yL, 'an Extended Sandwiched Double-Parallel Beta-strand (E)'}, ...
                {tL, 'Extended Sandwiched 2-Parallel Beta-Sheet'}, strcat(outfile, '_3'));
            plotBBRes(T, 4, 11);
            labelAndSave(afig, xL, {yL, 'an Extended Sandwiched (1P/1AP) Beta-strand (E)'}, ...
                {tL, 'Extended Beta-Sheet with 1 Parallel and 1 Anti-Parallel Partner'}, strcat(outfile, '_4'));
            plotBBRes(T, 5, 11);
            labelAndSave(afig, xL, {yL, 'an Extended Sandwiched Double-Anti-Parallel Beta-strand (E)'}, ...
                {tL, 'Extended Double-Anti-Parallel Beta-strand'}, strcat(outfile, '_5'));
            plotBBRes(T, 6, 11);
            labelAndSave(afig, xL, {yL, 'an Alpha Helix (H)'}, ...
                {tL, 'Alpha Helix'}, strcat(outfile, '_6'));
            plotBBRes(T, 7, 11);
            labelAndSave(afig, xL, {yL, 'a 3-10 Helix (G)'}, ...
                {tL, '3-10 Helix (G)'}, strcat(outfile, '_7'));
            plotBBRes(T, 8, 11);
            labelAndSave(afig, xL, {yL, 'a Pi Helix (I)'}, ...
                {tL, 'Pi Helix'}, strcat(outfile, '_8'));
            plotBBRes(T, 9, 11);
            labelAndSave(afig, xL, {yL, 'Any 3, 4, or 5-Residue-Spanning Turn (T)'}, ...
                {tL, 'Any 3, 4, or 5-Residue-Spanning Turn'}, strcat(outfile, '_9'));
            plotBBRes(T, 10, 11);
            labelAndSave(afig, xL, {yL, 'In a Bend (S)'}, ...
                {tL, 'In a Bend'}, strcat(outfile, '_10'));
            plotBBRes(T, 11, 11);
            labelAndSave(afig, xL, {yL, 'an Extended in Any Single/Double-Paired Beta-strand (E)'}, ...
                {tL, 'Extended in Any Single/Double-Paired Beta-strand'}, strcat(outfile, '_11'));
        % Only for DDSP +/- NORM
        case 10
            
        otherwise
            display('[FATAL ERROR]: Format specified is not valid');
    end
end

% Screens a matrix file, only outputing columns that aren't 0
function plotBBRes(A,t,tot)
    % Clear current data on the figure
    clf;
    iterants = (length(A.data)-1)/tot;
    % Determine which columns being looked at are worth plotting
    worthit = [];
    for i=1:iterants
        if sum(A.data(:,1+t+(i-1)*tot))>0
            worthit(end+1)=i;
        end
    end

    % Plot those columns
    col = hsv(length(worthit));
    hold on;
    x = A.data(:,1);
    hndl = [];
    for i=worthit
        hndl(end+1)=plot(x,A.data(:,1+t+(i-1)*tot));
    end
    labels = {};
    for i=1:length(hndl)
        labels{end+1}=strcat('Segments of length: ',num2str(i));
        set(hndl(i),'Color',col(i,:));
    end
    % Legend formatting
    hl=legend(labels,'Location','EastOutside');
    set(hl,'FontSize',12);
    hold off;
end
