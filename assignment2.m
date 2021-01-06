%% extracting features
 %run('sai_madhuri_molleti_assignment2.m');
 % run('model_file.m');

%% TESTING PHASE 
 testfile = readtable('test.csv');
 testfilearray = table2array(testfile);


windowmean = movmean(testfilearray ,6 ,2);
windowmean(:,2:4)=[];
windowmean(:,3:6)=[];
windowmean(:,4:7)=[];
windowmean(:,5:8)=[];
windowmean(:,6:8)=[];
Windowmean = array2table(windowmean);
Windowmean.Properties.VariableNames={'Windowmean1','Windowmean2','Windowmean3','Windowmean4','Windowmean5','Windowmean6'};
%% amplitude = cgm max - cgm min(1 feature)
maxcgmfortest = max(testfilearray ,[] ,2);
mincgmfortest = min(testfilearray,[],2);
cgmamplitudefortest = maxcgmfortest - mincgmfortest;
cgmamptest = array2table(cgmamplitudefortest);
cgmamptest.Properties.VariableNames={'Cgm amplitude'};
% %% cgm velocity(1 feature)
% testfile1 = testfile{:,:};
% testfile2 = diff(testfile1,1,2);
% testcgmvelocity = max(testfile2,[],2);
% testcgmvelocity1 = array2table(testcgmvelocity);
% testcgmvelocity1.Properties.VariableNames={'cgm velocity'};
%% fft 
fftfortestdata1 = fft(testfilearray,24,2);
powertest1 = abs(fftfortestdata1);
fftfortestdata2 = fft(testfilearray,12,2);
powertest2 = abs(fftfortestdata2);
testpower1 = max(powertest1,[],2);
testpower2 = max(powertest2 ,[] ,2);
powertest2(bsxfun(@eq, powertest2, testpower2)) = -Inf;
testpower3 = max(powertest2,[],2);
testpower1 = [testpower1,testpower2,testpower3];
totaltestpower = array2table(testpower1);
totaltestpower.Properties.VariableNames={'FFT1','FFT2','FFT3'};

% feature matrix for test file
testfeaturematrix = [Windowmean,cgmamptest,totaltestpower];
testfeaturematrix = table2array(testfeaturematrix);
yfit = trainedModel.predictFcn(testfeaturematrix);
yfit = array2table(yfit);
write(yfit,'Results1.csv');

