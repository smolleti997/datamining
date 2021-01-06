
%% training data 
%% for meal extraction
%m = readtable("InsulinAndMealIntake670GPatient3.xlsx");
m = readtable("InsulinData.csv");
columnY = m(:,25);
datem = datetime(m.Date);
timem = datenum(m.Time);
t1 = table(datem,timem);
 % Format both columns to MM/dd/yyyy HH:mm:SS for addition.
  datem = datetime(t1.datem,'Format','dd/MM/yyyy HH:mm:SS');
  timem = datetime(t1.timem,'ConvertFrom','datenum','Format','dd/MM/yyyy HH:mm:SS');
  % Add dates to times.
  fullt1 = datem+timeofday(timem);
  m.DatesNTimes = fullt1;
 
 % parse meal data
% n = readtable('CGMData670GPatient3.xlsx');
n = readtable("CGMData.csv");
 cgmdata = n(:,31);
 daten = datetime(n.Date);
timen = datenum(n.Time);
t2 = table(daten,timen);
 %%Format both columns to MM/dd/yyyy HH:mm:SS for addition.
 daten = datetime(t2.daten,'Format','dd/MM/yyyy HH:mm:SS');
 timen = datetime(t2.timen,'ConvertFrom','datenum','Format','dd/MM/yyyy HH:mm:SS');
 %%Add dates to times.
 fullt2 = daten+timeofday(timen);
 n.DatesNTimes = fullt2;
 % ignoring nan and null values, A has all the meal values,G has the row values at which the meal is non zero
 mealvals = table2array(columnY);
 [A] = (isnan(mealvals)) | (mealvals ==0);
 [G] = find(A==0);
 mealstarttimes = fullt1(G);
 
 %% requirement checking for meal time , c has values > 2 hrs ,d for less than 2 hrs , e for exact 2 hrs
 difinmealstarttime = diff(mealstarttimes);
 [C] = find(hours(difinmealstarttime)<-2);
 [D] = find(hours(difinmealstarttime)>-2);
 [E] = find(hours(difinmealstarttime)== -2);
 lessthantwo = mealstarttimes(D);
 maxi = size(lessthantwo);
 val = maxi(1);
 for i = val:-1:2
     tm = lessthantwo(i,1);
     tp = lessthantwo(i-1,1);
     if (hour(tp)>hour(tm)) && (hour(tp)<hour(tm)+2)
         lessthantwo(i)=[];
     elseif (hour(tp) == hour(tm)) && (minute(tp)>minute(tm))
         lessthantwo(i) =[];
     end
 end
 greaterthantwo = mealstarttimes(C);   
 equaltotwo = mealstarttimes(E);
 max1 = size(equaltotwo);
 val1 = max1(1);
 for j = val1:-1:2
     tn = equaltotwo(j,1);
     ts = equaltotwo(j-1,1);
     if(hour(ts) - hour(tp)==2)
         hour(tn) = hour(tn) +1;
         minute(tn) = minute(tn) +30;
         hour(ts) = hour(tn) +4 ;
     end
 end
 finaldateandtime =vertcat(greaterthantwo,lessthantwo,equaltotwo);    
 
 %% meal data matrix
  mealdatamatrix = [];
  max2 = size(finaldateandtime);
  val2 =max2(1);
  
  for k = 1:val2
      [H] = find(fullt2 >finaldateandtime(k));
      matchingval = size(H);
      matchval = matchingval(1);
      cgmdate = fullt2(matchval);
      
      maxval = matchval + 6 ;
      if maxval > height(n)
         k = k +1;
         break;
      end
      minval = matchval -23;
      mealdatavector = array2table(zeros(1,30));
      %mealdatavector.Properties.VariableNames = {'SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_'};
      %%for it= minval:1:maxval
         cgm = cgmdata(minval:maxval,1);
         %cgmd = table2cell(cgm);
         YourArray = table2array(cgm);
         YourNewTable = array2table(YourArray.');

         cgm.Properties.VariableNames ={ ' '};
      %end 
      mealdatavector =[mealdatavector; YourNewTable];
      mealdatavector(1,:)=[];
      mealdatav = table2array(mealdatavector);
      [AB] = isnan(mealdatav);
      if (AB ==0)
          mealdatamatrix = [mealdatamatrix ; mealdatavector];
      else
         % mealdatamatrix = [mealdatamatrix ; mealdatavector];
      end
         % mealdatamatrix =[mealdatamatrix;mealdatavector];
      
  end
 %mealdatamatrix.Properties,VariableNames ={'Sensor_Glucose_mg_dL_1','Sensor_Glucose_mg_dL_2','Sensor_Glucose_mg_dL_3','Sensor_Glucose_mg_dL_4','Sensor_Glucose_mg_dL_5','Sensor_Glucose_mg_dL_6','Sensor_Glucose_mg_dL_7','Sensor_Glucose_mg_dL_8','Sensor_Glucose_mg_dL_9','Sensor_Glucose_mg_dL_10','Sensor_Glucose_mg_dL_11','Sensor_Glucose_mg_dL_12','Sensor_Glucose_mg_dL_13','Sensor_Glucose_mg_dL_14','Sensor_Glucose_mg_dL_15','Sensor_Glucose_mg_dL_16','Sensor_Glucose_mg_dL_17','Sensor_Glucose_mg_dL_18','Sensor_Glucose_mg_dL_19','Sensor_Glucose_mg_dL_20','Sensor_Glucose_mg_dL_21','Sensor_Glucose_mg_dL_22','Sensor_Glucose_mg_dL_23','Sensor_Glucose_mg_dL_24','Sensor_Glucose_mg_dL_25','Sensor_Glucose_mg_dL_26','Sensor_Glucose_mg_dL_27','Sensor_Glucose_mg_dL_28','Sensor_Glucose_mg_dL_29','Sensor_Glucose_mg_dL_30'};

 

 
        
 %mealdatamatrix.Properties,VariableNames ={'Sensor_Glucose_mg_dL_1','Sensor_Glucose_mg_dL_2','Sensor_Glucose_mg_dL_3','Sensor_Glucose_mg_dL_4','Sensor_Glucose_mg_dL_5','Sensor_Glucose_mg_dL_6','Sensor_Glucose_mg_dL_7','Sensor_Glucose_mg_dL_8','Sensor_Glucose_mg_dL_9','Sensor_Glucose_mg_dL_10','Sensor_Glucose_mg_dL_11','Sensor_Glucose_mg_dL_12','Sensor_Glucose_mg_dL_13','Sensor_Glucose_mg_dL_14','Sensor_Glucose_mg_dL_15','Sensor_Glucose_mg_dL_16','Sensor_Glucose_mg_dL_17','Sensor_Glucose_mg_dL_18','Sensor_Glucose_mg_dL_19','Sensor_Glucose_mg_dL_20','Sensor_Glucose_mg_dL_21','Sensor_Glucose_mg_dL_22','Sensor_Glucose_mg_dL_23','Sensor_Glucose_mg_dL_24','Sensor_Glucose_mg_dL_25','Sensor_Glucose_mg_dL_26','Sensor_Glucose_mg_dL_27','Sensor_Glucose_mg_dL_28','Sensor_Glucose_mg_dL_29','Sensor_Glucose_mg_dL_30'};
 

 %% no meal extraction
 [L]= find(hours(difinmealstarttime)<-4);
 greaterthanfour = mealstarttimes(L);
 sizeofnomeal = size(greaterthanfour);
 max4 = sizeofnomeal(1);
 for t = 1: max4
     %hour1=greaterthanfour(t,1);
     greaterthanfour(t,1) = greaterthanfour(t,1) + hours(2);
     %hour(greaterthanfour(t,1))= hour2;
 end 
 %% no meal matrix 
 
 nomealdatamatrix = [];
  for ki = 1:max4
      [Hi] = find(fullt2 > greaterthanfour(ki));
      matchingval1 = size(Hi);
      matchval1 = matchingval1(1);
      nomealcgmdate = fullt2(matchval1);
      maxval1 = matchval1 ;
      minval1 = matchval1-23;
      nomealdatavector = array2table(zeros(1,24));
      %mealdatavector.Properties.VariableNames = {'SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_'};
      %%for it= minval:1:maxval
         cgm1 = cgmdata(minval1:maxval1,1);
         YourArray1 = table2array(cgm1);
         YourNewTable1 = array2table(YourArray1.');
         cgm1.Properties.VariableNames ={ ' '};
      %end 
      nomealdatavector =[nomealdatavector; YourNewTable1];
      nomealdatavector(1,:)=[];
      nomealdatav = table2array(nomealdatavector);
      [ABC] = isnan(nomealdatav);
      if (ABC ==0)
          nomealdatamatrix = [nomealdatamatrix ; nomealdatavector];
        
      end
  end
 
 %% meal data is in mealdatamatrix and no meal data is in nomealdatamatrix
% write(mealdatamatrix , 'meal1.csv');
 % write(nomealdatamatrix ,'nomeal1.csv');
 
 write(mealdatamatrix , 'meal2.csv');
 write(nomealdatamatrix , 'nomeal2.csv');
 csv1 = readtable('meal1.csv');
csv2 = readtable('meal2.csv');
csv3 = readtable('nomeal1.csv');
csv4 = readtable('nomeal2.csv');
mealcsv = [csv1;csv2]; % Concatenate vertically
nomealcsv = [csv3;csv4];
write(mealcsv,'meal.csv');
write(nomealcsv ,'nomeal.csv');
%% extracting features

%%s = load('sai_madhuri_molleti_assignment2.mat');
mealdata = readtable('meal.csv');
nomealdata = readtable('nomeal.csv');
  %% windowed mean for meal and no meal (6 features)
mealdataarray = table2array(mealdata);
windowmeal = movmean(mealdataarray , 6 ,2);
 windowmeal(:,2:5) = [];
 windowmeal(:,3:7)=[];
 windowmeal(:,4:8) = [];
 windowmeal(:,5:9) =[];
 windowmeal(:,6:10) = [];
Windowmeal = array2table(windowmeal);
Windowmeal.Properties.VariableNames = {'windowmean1','windowmean2','windowmean3','windowmean4','windowmean5','windowmean6'};
nomealdataarray =table2array(nomealdata);
windownomeal = movmean(nomealdataarray ,6 ,2);
windownomeal(:,2:4)=[];
windownomeal(:,3:6)=[];
windownomeal(:,4:7)=[];
windownomeal(:,5:8)=[];
windownomeal(:,6:8)=[];
Windownomeal = array2table(windownomeal);
Windownomeal.Properties.VariableNames={'windowmean1','windowmean2','windowmean3','windowmean4','windowmean5','windowmean6'};
%% amplitude = cgm max - cgm min(1 feature)
%%[M1,L1] = fread(secret,'ubit1'); 
mincgmformeal = min(mealdataarray,[],2);
maxcgmformeal = max(mealdataarray,[],2);
% maxcgmformeal = [];
% for ii = 1:1168
%     maxvalueofrow = max(mealdataarray(i,:));
%     maxcgmformeal = [maxcgmformeal ; maxvaleofrow];
% end
cgmamplitudemeal = maxcgmformeal-mincgmformeal;
cgmampmeal = array2table(cgmamplitudemeal);
cgmampmeal.Properties.VariableNames ={'cgm value'};
maxcgmfornomeal = max(nomealdataarray ,[] ,2);
mincgmfornomeal = min(nomealdataarray,[],2);
cgmamplitudenomeal = maxcgmfornomeal - mincgmfornomeal;
cgmampnomeal = array2table(cgmamplitudenomeal);
cgmampnomeal.Properties.VariableNames={'cgm value'};
% %% cgm velocity(1 feature)
% mealdata1 = mealdata{:,:};
% mealdata2 = diff(mealdata1,1,2);
% mealcgmvelocity = max(mealdata2,[],2);
% mealcgmvelocity1 = array2table(mealcgmvelocity);
% mealcgmvelocity1.Properties.VariableNames={'cgm velocity'};
% nomealdata1 = nomealdata{:,:};
% nomealdata2 = diff(nomealdata1,1,2);
% nomealcgmvelocity = max(nomealdata2 , [] ,2);
% nomealcgmvelocity1 = array2table(nomealcgmvelocity);
% nomealcgmvelocity1.Properties.VariableNames={'cgm velocity'};

%% fast fourier transform (3 features)
fftformealdata1 = fft(mealdataarray,30,2);
power1 = abs(fftformealdata1);
fftformealdata2 = fft(mealdataarray,15,2);
power2 = abs(fftformealdata2);
mealpower1 = max(power1,[],2);
mealpower2 = max(power2 ,[] ,2);
power2(bsxfun(@eq, power2, mealpower2)) = -Inf;
mealpower3 = max(power2,[],2);
mealpower1 = [mealpower1,mealpower2,mealpower3];
totalmealpower = array2table(mealpower1);
totalmealpower.Properties.VariableNames={'Power1','Power2','Power3'};

fftfornomealdata1 = fft(nomealdataarray,24,2);
power3 = abs(fftfornomealdata1);
fftfornomealdata2 = fft(nomealdataarray,12,2);
power4 = abs(fftfornomealdata2);
nomealpower1 = max(power3,[],2);
nomealpower2 = max(power4 ,[] ,2);
power4(bsxfun(@eq, power4, nomealpower2)) = -Inf;
nomealpower3 = max(power4,[],2);
nomealpower1 = [nomealpower1 , nomealpower2,nomealpower3];
totalnomealpower = array2table(nomealpower1);
totalnomealpower.Properties.VariableNames ={'Power1','Power2','Power3'};
mat1 = ones(size(totalmealpower,1));
mat1 = array2table(mat1);
mat1 = mat1(:,1);
mat1.Properties.VariableNames ={'Class'};
mat2 = zeros(size(totalnomealpower,1));
mat2 = array2table(mat2);
mat2 = mat2(:,1);
mat2.Properties.VariableNames ={'Class'};

%% total data
 mealfeature =[Windowmeal,cgmampmeal,totalmealpower, mat1];
nomealfeature =[Windownomeal,cgmampnomeal,totalnomealpower, mat2] ;
 totaldata = [mealfeature ; nomealfeature];
 totaldata = totaldata{:,:};
 sizeofdata = size(totaldata);
 size = sizeofdata(1);
 P = 0.8;
 idx = randperm(size);
 Training = totaldata(idx(1:round(P*size)),:) ; 
 Testing = totaldata(idx(round(P*size)+1:end),:) ;
 training = array2table(Training);
 training.Properties.VariableNames ={'Windowmean1','Windowmean2','Windowmean3','Windowmean4','Windowmean5','Windowmean6','Cgm amplitude','FFT1','FFT2','FFT3','Class'};
 testing = array2table(Testing);
 testing.Properties.VariableNames ={'Windowmean1','Windowmean2','Windowmean3','Windowmean4','Windowmean5','Windowmean6','Cgm amplitude','FFT1','FFT2','FFT3','Class'};
% colNames = {'Windowmean1','Windowmean2','Windowmean3','Windowmean4','Windowmean5','Windowmean6','Cgm amplitude','Cgm velocity','FFT1','FFT2','FFT3'};
% colNames = {'x','y','z'};
% sTable = array2table(sample,'RowNames',rowNames,'VariableNames',colNames)
