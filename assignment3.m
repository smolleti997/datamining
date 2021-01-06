%for ground truth 
m = readtable("InsulinData.csv");
columnY = m(:,25);
Y = table2array(columnY);
%finding min and max of y column 
[A] = (isnan(Y)) | (Y ==0);
[G] = find(A==0);
Y=Y(G);
minmealvalue =min(Y);
maxmealvalue =max(Y);
range = maxmealvalue - minmealvalue;
bin1 =[minmealvalue,minmealvalue+20];
bin2 =[minmealvalue+20,minmealvalue+40];
bin3 =[minmealvalue+40,minmealvalue+60];
bin4 =[minmealvalue+60,minmealvalue+80];
bin5 =[minmealvalue+80,minmealvalue+100];
bin6 =[minmealvalue+100,minmealvalue+120];
bin7 =[minmealvalue+120,maxmealvalue];
numofbins = range/20;
%% for meal extraction
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
 mealvals =mealvals(G);
 mealstarttimes = fullt1(G);
 
 %% requirement checking for meal time , c has values > 2 hrs ,d for less than 2 hrs , e for exact 2 hrs
 difinmealstarttime = diff(mealstarttimes);
 [C] = find(hours(difinmealstarttime)<-2);
 [D] = find(hours(difinmealstarttime)>-2);
 [E] = find(hours(difinmealstarttime)== -2);

 D1 = mealstarttimes(D);
 Dcol = mealvals(D);
 D1 = array2table(D1);
 Dcol = array2table(Dcol);
 lessthantwo =[D1,Dcol];
 maxi = height(lessthantwo);
 for i = maxi:-1:2
     tm = lessthantwo(i,1);
     tp = lessthantwo(i-1,1);
     tm = table2array(tm);
     tp = table2array(tp);
     if (hour(tp)>hour(tm)) && (hour(tp)<hour(tm)+2)
         lessthantwo(i,:)=[];
     elseif (hour(tp) == hour(tm)) && (minute(tp)>minute(tm))
         lessthantwo(i,:)=[];
     end
 end
 C1 = mealstarttimes(C);
 Ccol = mealvals(C);
 C1 = array2table(C1);
 Ccol = array2table(Ccol);
 greaterthantwo = [C1,Ccol];   
 E1 = mealstarttimes(E);
 Ecol = mealvals(E);
 E1 = array2table(E1);
 Ecol = array2table(Ecol);
 equaltotwo =[E1,Ecol];
 max1 = height(equaltotwo);
 for j = max1:-1:2
     tn = equaltotwo(j,1);
     ts = equaltotwo(j-1,1);
     tn = table2array(tn);
     ts = table2array(ts);
     if(hour(ts) - hour(tp)==2)
         hour(tn) = hour(tn) +1;
         minute(tn) = minute(tn) +30;
         hour(ts) = hour(tn) +4 ;
     end
 end
 lessthantwo.Properties.VariableNames = {'Timestamp' 'Y'}
 equaltotwo.Properties.VariableNames = {'Timestamp' 'Y'}
 greaterthantwo.Properties.VariableNames = {'Timestamp' 'Y'}
 finaldateandtime =vertcat(greaterthantwo,lessthantwo,equaltotwo);    
 
 %% meal data matrix
  Groundtruth = [];
  max2 = height(finaldateandtime);
  
  
  for k = 1:max2
      datetime = table2array(finaldateandtime(:,1));
      [H] = find(fullt2 >datetime(k));
      matchingval = size(H);
      matchval = matchingval(1);
      cgmdate = fullt2(matchval);
      yvalue = finaldateandtime(k,2);
      yvalue.Properties.VariableNames ={'Var31'};
      maxval = matchval + 6 ;
      if maxval > height(n)
         k = k +1;
         break;
      end
      minval = matchval -23;
      mealdatavector = array2table(zeros(1,31));
      %mealdatavector.Properties.VariableNames = {'SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_','SensorGlucose_mg_dL_'};
      %%for it= minval:1:maxval
         cgm = cgmdata(minval:maxval,1);
%          cgm = table2cell(cgm);
%          cgm = cell2table(cgm);
         YourArray = table2array(cgm);
         YourArray = array2table(YourArray.');

         cgm.Properties.VariableNames ={ ' '};
      %end 
      mealdatavector =[mealdatavector; YourArray,yvalue];
      mealdatavector(1,:)=[];
      mealdatav = table2array(mealdatavector);
      [AB] = isnan(mealdatav);
      if (AB ==0)
          Groundtruth = [Groundtruth ; mealdatavector];
      else
         % mealdatamatrix = [mealdatamatrix ; mealdatavector];
      end
         % mealdatamatrix =[mealdatamatrix;mealdatavector];
      
  end
 Groundtruth.Properties.VariableNames ={'Sensor_Glucose_mg_dL_1','Sensor_Glucose_mg_dL_2','Sensor_Glucose_mg_dL_3','Sensor_Glucose_mg_dL_4','Sensor_Glucose_mg_dL_5','Sensor_Glucose_mg_dL_6','Sensor_Glucose_mg_dL_7','Sensor_Glucose_mg_dL_8','Sensor_Glucose_mg_dL_9','Sensor_Glucose_mg_dL_10','Sensor_Glucose_mg_dL_11','Sensor_Glucose_mg_dL_12','Sensor_Glucose_mg_dL_13','Sensor_Glucose_mg_dL_14','Sensor_Glucose_mg_dL_15','Sensor_Glucose_mg_dL_16','Sensor_Glucose_mg_dL_17','Sensor_Glucose_mg_dL_18','Sensor_Glucose_mg_dL_19','Sensor_Glucose_mg_dL_20','Sensor_Glucose_mg_dL_21','Sensor_Glucose_mg_dL_22','Sensor_Glucose_mg_dL_23','Sensor_Glucose_mg_dL_24','Sensor_Glucose_mg_dL_25','Sensor_Glucose_mg_dL_26','Sensor_Glucose_mg_dL_27','Sensor_Glucose_mg_dL_28','Sensor_Glucose_mg_dL_29','Sensor_Glucose_mg_dL_30','Y'};

        
 %mealdatamatrix.Properties,VariableNames ={'Sensor_Glucose_mg_dL_1','Sensor_Glucose_mg_dL_2','Sensor_Glucose_mg_dL_3','Sensor_Glucose_mg_dL_4','Sensor_Glucose_mg_dL_5','Sensor_Glucose_mg_dL_6','Sensor_Glucose_mg_dL_7','Sensor_Glucose_mg_dL_8','Sensor_Glucose_mg_dL_9','Sensor_Glucose_mg_dL_10','Sensor_Glucose_mg_dL_11','Sensor_Glucose_mg_dL_12','Sensor_Glucose_mg_dL_13','Sensor_Glucose_mg_dL_14','Sensor_Glucose_mg_dL_15','Sensor_Glucose_mg_dL_16','Sensor_Glucose_mg_dL_17','Sensor_Glucose_mg_dL_18','Sensor_Glucose_mg_dL_19','Sensor_Glucose_mg_dL_20','Sensor_Glucose_mg_dL_21','Sensor_Glucose_mg_dL_22','Sensor_Glucose_mg_dL_23','Sensor_Glucose_mg_dL_24','Sensor_Glucose_mg_dL_25','Sensor_Glucose_mg_dL_26','Sensor_Glucose_mg_dL_27','Sensor_Glucose_mg_dL_28','Sensor_Glucose_mg_dL_29','Sensor_Glucose_mg_dL_30'};
 


%% adding bin number to mealdatamatrix
carbvalue = Groundtruth(:,31);
bin=[];
carbvalue1 = table2array(carbvalue);
for len=1:height(carbvalue)
    if carbvalue1(len,1)>=3 && carbvalue1(len,1)<=23
        bin =[bin;1];
    elseif carbvalue1(len,1)>23 && carbvalue1(len,1)<=43
        bin =[bin;2];
    elseif carbvalue1(len,1)>43 && carbvalue1(len,1)<=63
        bin =[bin;3];
    elseif carbvalue1(len,1)>63 && carbvalue1(len,1)<=83
        bin = [bin;4];
    elseif carbvalue1(len,1)>83 && carbvalue1(len,1)<=103
        bin = [bin;5];
    elseif carbvalue1(len,1)>103 && carbvalue1(len,1) <=123
        bin=[bin;6];
    elseif carbvalue1(len,1)>123 && carbvalue1(len,1)<=129
        bin =[bin;7];
    end
end
bin = array2table(bin);
Groundtruth=[Groundtruth,bin];
%% extracting features 
 lessthantwo1 = mealstarttimes(D);
 maxi1 = size(lessthantwo1);
 val = maxi1(1);
 for i = val:-1:2
     tm = lessthantwo1(i,1);
     tp = lessthantwo1(i-1,1);
     if (hour(tp)>hour(tm)) && (hour(tp)<hour(tm)+2)
         lessthantwo1(i)=[];
     elseif (hour(tp) == hour(tm)) && (minute(tp)>minute(tm))
         lessthantwo1(i) =[];
     end
 end
 greaterthantwo1 = mealstarttimes(C);   
 equaltotwo1 = mealstarttimes(E);
 max11 = size(equaltotwo);
 val11 = max11(1);
 for j = val11:-1:2
     tn = equaltotwo1(j,1);
     ts = equaltotwo1(j-1,1);
     if(hour(ts) - hour(tp)==2)
         hour(tn) = hour(tn) +1;
         minute(tn) = minute(tn) +30;
         hour(ts) = hour(tn) +4 ;
     end
 end
 finaldateandtime1 =vertcat(greaterthantwo1,lessthantwo1,equaltotwo1);    
 
 %% meal data matrix
  mealdatamatrix = [];
  max2 = size(finaldateandtime1);
  val2 =max2(1);
  
  for k = 1:val2
      [H] = find(fullt2 >finaldateandtime1(k));
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
 

%% windowed mean for meal and no meal (6 features)
mealdataarray = table2array(mealdatamatrix);
windowmeal = movmean(mealdataarray , 6 ,2);
 windowmeal(:,2:5) = [];
 windowmeal(:,3:7)=[];
 windowmeal(:,4:8) = [];
 windowmeal(:,5:9) =[];
 windowmeal(:,6:11) = [];
Windowmeal = array2table(windowmeal);
Windowmeal.Properties.VariableNames = {'windowmean1','windowmean2','windowmean3','windowmean4','windowmean5'};
%% amplitude = cgm max - cgm min(1 feature)
%%[M1,L1] = fread(secret,'ubit1'); 
mincgmformeal = min(mealdataarray,[],2);
maxcgmformeal = max(mealdataarray,[],2);
cgmamplitudemeal = maxcgmformeal-mincgmformeal;
cgmampmeal = array2table(cgmamplitudemeal);
cgmampmeal.Properties.VariableNames ={'cgm value'};
%% fast fourier transform (3 features)
fftformealdata1 = fft(mealdataarray,30,2);
power1 = abs(fftformealdata1);
power1(:,1)=0;
fftformealdata2 = fft(mealdataarray,15,2);
power2 = abs(fftformealdata2);
power2(:,1)=0;
mealpower1 = max(power1,[],2);
mealpower2 = max(power2 ,[] ,2);
power2(bsxfun(@eq, power2, mealpower2)) = -Inf;
mealpower3 = max(power2,[],2);
mealpower1 = [mealpower1,mealpower2,mealpower3];
totalmealpower = array2table(mealpower1);
totalmealpower.Properties.VariableNames={'Power1','Power2','Power3'};
%% cgm velocity
lengthmealdata =size(mealdataarray);
len2 = lengthmealdata(1,2);
diff =[];
for i=1:len2-1
    diff =[diff, (mealdataarray(:,i)-mealdataarray(:,i+1))];
end

    cgmvelocity = max(diff,[],2);
    cgmvelocity = array2table(cgmvelocity);
    cgmvelocity.Properties.VariableNames ={'velocity'};
diff2 = [];
for i =1:len2-2
    diff2 =[diff2,(diff(:,i)-diff(:,i+1))];
end
cgmacc = max(diff2,[],2);
cgmacc = array2table(cgmacc);
cgmacc.Properties.VariableNames={'acceleration'};
    
mat1 = ones(size(totalmealpower,1));
mat1 =array2table(mat1);
mat1 = mat1(:,1);
%% total data
 mealfeature =[Windowmeal,cgmampmeal,totalmealpower,cgmvelocity,cgmacc];
 %% clustering using kmeans
 mealfeaturearray = table2array(mealfeature);
 mealfeaturearray =[mealfeaturearray];
  [ix,C,Sumd] = kmeans(mealfeaturearray,7,'Distance','sqeuclidean');
  SSEforkmeans=Sumd(1,1);
  for count =2:7
    
        SSEforkmeans = SSEforkmeans + Sumd(count,1);
    
  end 
% [cidx ,ctrs] = kmeans(mealfeaturearray , 7,'Distance','seuclidean');
% length= size(cidx);
% cidxlen = length(1);
% SSE1 =0;
% SSE2=0;
% SSE3=0;
% SSE4=0;
% SSE5=0;
% SSE6=0;
% SSE7=0;
% for it =1:cidxlen
%     if cidx(it) ==1
%         SSE1 = SSE1 + (mealfeaturearray(it,:)-ctrs(1,:)).^2;
%     elseif cidx(it)==2
%         SSE2 =SSE2 +(mealfeaturearray(it,:)-ctrs(2,:)).^2;
%     elseif cidx(it) ==3
%         SSE3 =SSE3 +(mealfeaturearray(it,:)-ctrs(3,:)).^2;
%     elseif cidx(it) ==4
%         SSE4 =SSE4 +(mealfeaturearray(it,:)-ctrs(4,:)).^2;
%     elseif cidx(it) ==5
%         SSE5 =SSE5 +(mealfeaturearray(it,:)-ctrs(5,:)).^2;
%     elseif cidx(it) ==6
%         SSE6 =SSE6 +(mealfeaturearray(it,:)-ctrs(6,:)).^2;
%     elseif cidx(it) ==7
%         SSE7 =SSE7 +(mealfeaturearray(it,:)-ctrs(7,:)).^2;
%     end
% end
for m1 = 1:544
    Entropy(m1) = sum(-mealfeaturearray(m1,:)/sum(mealfeaturearray(m1,:)) .* log(mealfeaturearray(m1,:)/sum(mealfeaturearray(m1,:)))/log(2));
    Purity(m1) = max(mealfeaturearray(m1,:))/sum(mealfeaturearray(m1,:));
end
y12 = isnan(Entropy);
Y1 =find(y12==1);
Entropy(Y1)=0;

TotalP = sum(mealfeaturearray,1);
WholeEntropyforkmeans = 0;
WholePurityforkmeans = 0;
for im = 1:544
    
    WholeEntropyforkmeans = WholeEntropyforkmeans + ((sum(mealfeaturearray(im,:)))/(sum(TotalP)))*Entropy(im);
    WholePurityforkmeans = WholePurityforkmeans + ((sum(mealfeaturearray(im,:)))/(sum(TotalP)))*Purity(im);
end

 %% clustering using dbscan
 idx = dbscan(mealfeaturearray,97,6);
 mealfeaturearray1 = [mealfeaturearray ,idx];
 [ix1,C1,Sumd1] = kmeans(mealfeaturearray1,7);
  SSEfordbscan=Sumd1(1,1);
  for count1 =2:7
    
        SSEfordbscan = SSEfordbscan + Sumd1(count1,1);
    
  end 
  for m2 = 1:544
    Entropy1(m2) = sum(-mealfeaturearray1(m2,:)/sum(mealfeaturearray1(m2,:)) .* log(mealfeaturearray1(m2,:)/sum(mealfeaturearray1(m2,:)))/log(2));
    Purity1(m2) = max(mealfeaturearray1(m2,:))/sum(mealfeaturearray1(m2,:));
  end
y12 = isnan(Entropy1);
Y1 =find(y12==1);
Entropy1(Y1)=0;

TotalP1 = sum(mealfeaturearray1,1);
WholeEntropyfordbscan = 0;
WholePurityfordbscan = 0;
for im1 = 1:544
    
    WholeEntropyfordbscan = WholeEntropyfordbscan + ((sum(mealfeaturearray1(im1,:)))/(sum(TotalP1)))*Entropy1(im1);
    WholePurityfordbscan = WholePurityfordbscan + ((sum(mealfeaturearray1(im1,:)))/(sum(TotalP1)))*Purity1(im1);
end
%% writing results
finally = [SSEforkmeans,SSEfordbscan,WholeEntropyforkmeans,WholeEntropyfordbscan,WholePurityforkmeans,WholePurityfordbscan];
csvwrite('Results_hw3.csv',finally);
