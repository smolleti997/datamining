
% ...Import input csv files...
   
m = readtable('InsulinData.csv');
n = readtable('CGMData.csv');

... For interpolating CGM values...
n.SensorGlucose_mg_dL_=fillmissing(n.SensorGlucose_mg_dL_ ,'previous');
   
...making date and time column in table m 
  datem = datetime(m.Date);
  timem = datenum(m.Time);
   t = table(datem,timem);
 %Format both columns to MM/dd/yyyy HH:mm:SS for addition.
 datem = datetime(t.datem,'Format','dd/MM/yyyy HH:mm:SS');
 timem = datetime(t.timem,'ConvertFrom','datenum','Format','dd/MM/yyyy HH:mm:SS');
 %Add dates to times.
 fullt = datem+timeofday(timem);
 m.DatesNTimes = fullt;
 
 
...making date and time column in table n   
  daten = datetime(n.Date);
  timen = datenum(n.Time);
   s = table(daten,timen);
 %Format both columns to MM/dd/yyyy HH:mm:SS for addition.
 daten = datetime(s.daten,'Format','dd/MM/yyyy HH:mm:SS');
 timen = datetime(s.timen,'ConvertFrom','datenum','Format','dd/MM/yyyy HH:mm:SS');
 %Add dates to times.
 fulls = daten+timeofday(timen);
 n.DatesNTimes = fulls;
    
...seperating auto and manual mode
  cl = find(strcmp(m.Properties.VariableNames ,'Alarm'));
 arr =table2array(m(:,cl));
 c =zeros(1,1);
for r =1:height(m)
    str =["AUTO MODE ACTIVE PLGM OFF"];
    c = [c ; arr(r,1)];
       tf= strcmp(c , str);   
end
col =zeros(1,1);
for ro =1:height(m)
    if tf(ro,1)==1
        col=[col;ro];
    end
end

maxi = max(col);
datentimeinm = find(strcmp(m.Properties.VariableNames ,'DatesNTimes'));
mm = m(maxi,datentimeinm);
mm1 =table2array(mm);
t1 = datetime(mm1,'InputFormat','dd-MMM-yyyy HH:mm:ss');

datentimeinn =find(strcmp(n.Properties.VariableNames, 'DatesNTimes'));

arr2 = table2array(n(:,[datentimeinn]));
for var = 1:height(n)
    ar2 = arr2(var,1);
if (ar2.Year == t1.Year) && (ar2.Month == t1.Month)&& (ar2.Day == t1.Day)&&(ar2.Hour == t1.Hour)&&(ar2.Minute-t1.Minute<=4);
var1=var;
end
end
   
  
     ... values in auto mode...
     ... day values...
       
 sgc =find(strcmp(n.Properties.VariableNames, 'SensorGlucose_mg_dL_'));

sgcarr = table2array(n(:,[sgc]));
   
    
    a = [hour(n.DatesNTimes)];
 CGMdayAuto1 =0;
 CGMdayAuto2=0;
 CGMdayAuto3 =0;
 CGMdayAuto4 = 0;
 CGMdayAuto5 =0;
 CGMdayAuto6 =0;
 CGMnightAuto1 =0;
 CGMnightAuto2 =0;
 CGMnightAuto3 =0;
 CGMnightAuto4 =0;
 CGMnightAuto5 =0;
 CGMnightAuto6 =0;
 CGMwholeAuto1=0;
 CGMwholeAuto2=0;
 CGMwholeAuto3=0;
 CGMwholeAuto4=0;
 CGMwholeAuto5=0;
 CGMwholeAuto6=0;
 
  CGMdayManual1 =0;
 CGMdayManual2=0;
 CGMdayManual3 =0;
 CGMdayManual4 = 0;
 CGMdayManual5 =0;
 CGMdayManual6 =0;
 CGMnightManual1 =0;
 CGMnightManual2 =0;
 CGMnightManual3 =0;
 CGMnightManual4 =0;
 CGMnightManual5 =0;
 CGMnightManual6 =0;
 CGMwholeManual1=0;
 CGMwholeManual2=0;
 CGMwholeManual3=0;
 CGMwholeManual4=0;
 CGMwholeManual5=0;
 CGMwholeManual6=0;

     for www=1:var1
          
     if ( a(www,1)>=6)&& ( a(www,1)<=23)
         
         if sgcarr(www,1)>180
             CGMdayAuto1 = CGMdayAuto1 +1 ;
         end
         if  sgcarr(www,1)>250
           CGMdayAuto2 = CGMdayAuto2 + 1 ;
         end
         if(sgcarr(www,1)>=70)&&(sgcarr(www,1)<=180)
             CGMdayAuto3=CGMdayAuto3 +1;
         end
         if(sgcarr(www,1)>=70)&&(sgcarr(www,1)<=150)
             CGMdayAuto4 =CGMdayAuto4 +1;
         end
         if sgcarr(www,1)<70
             CGMdayAuto5 =CGMdayAuto5 +1 ;
         end
         if sgcarr(www,1)<54
             CGMdayAuto6 =CGMdayAuto6 +1 ;
         end
     end
         ...night values...
     if( a(www,1)>=0) && ( a(www,1)<=6)
     
         if sgcarr(www,1)>180
             CGMnightAuto1 = CGMnightAuto1 + 1 ;
         end
         if sgcarr(www,1)>250
           CGMnightAuto2 = CGMnightAuto2 + 1;
         end
         if(sgcarr(www,1)>=70)&&(sgcarr(www,1)<=180)
             CGMnightAuto3=CGMnightAuto3 + 1;
         end  
         if(sgcarr(www,1)>=70) && (sgcarr(www,1)<=150)
             CGMnightAuto4 =CGMnightAuto4 +1;
         end   
         if sgcarr(www,1)<70
             CGMnightAuto5 =CGMnightAuto5 +1;
         end 
         if sgcarr(www,1) <54
             CGMnightAuto6 =CGMnightAuto6 + 1;
         end
     end
         ... whole day values...
      if( a(www,1)>=0)&&( a(www,1)<=23)
          if sgcarr(www,1)>180
             CGMwholeAuto1 = CGMwholeAuto1 + 1 ;
          end
          if sgcarr(www,1) >250
           CGMwholeAuto2 = CGMwholeAuto2 + 1;
          end
          if (sgcarr(www,1)>=70)&&(sgcarr(www,1)<=180)
             CGMwholeAuto3 = CGMwholeAuto3 + 1;
          end
         if(sgcarr(www,1)>=70) && (sgcarr(www,1)<=150)
             CGMwholeAuto4 = CGMwholeAuto4 +1;
         end 
          if sgcarr(www,1)<70
             CGMwholeAuto5 = CGMwholeAuto5 + 1;
          end
          if sgcarr(www,1) <54
             CGMwholeAuto6 = CGMwholeAuto6 + 1;
          end
      end
     
     end
     


     ...for manual mode ...
     ....day values....
     for xxx =var1:height(n)
        if ( a(xxx,1)>=6)&& ( a(xxx,1)<=23)
         if sgcarr(xxx,1)>180
             CGMdayManual1 = CGMdayManual1 +1 ;
         end
         if sgcarr(xxx,1)>250
           CGMdayManual2 = CGMdayManual2 +1;
         end
         if(sgcarr(xxx,1)>=70)&&(sgcarr(xxx,1)<=180)
             CGMdayManual3=CGMdayManual3 +1;
         end 
         if(sgcarr(xxx,1)>=70)&&(sgcarr(xxx,1)<=150)
             CGMdayManual4 =CGMdayManual4 +1;
         end 
         if sgcarr(xxx,1)<70
             CGMdayManual5 =CGMdayManual5 +1 ;
         end 
         if sgcarr(xxx,1) <54
             CGMdayManual6 =CGMdayManual6 +1 ;
         end 
        end
      ....night values   
     if( a(xxx,1)>=0) && ( a(xxx,1)<=6)
         if sgcarr(xxx,1)>180
             CGMnightManual1 = CGMnightManual1 + 1 ;
         end
         if sgcarr(xxx,1)>250
           CGMnightManual2 = CGMnightManual2 + 1;
         end
         if(sgcarr(xxx,1)>=70)&&(sgcarr(xxx,1)<=180)
             CGMnightManual3=CGMnightManual3 + 1;
         end 
         if(sgcarr(xxx,1)>=70) && (sgcarr(xxx,1)<=150)
             CGMnightManual4 =CGMnightManual4 +1;
         end 
         if sgcarr(xxx,1)<70
             CGMnightManual5 =CGMnightManual5 +1;
         end  
         if sgcarr(xxx,1) <54
             CGMnightManual6 =CGMnightManual6 + 1;
         end
     end
      ... whole day values...   
     if( a(xxx,1)>=0)&&( a(xxx,1)<=23)
          if sgcarr(xxx,1)>180
             CGMwholeManual1 = CGMwholeManual1 + 1 ;
          end
          if sgcarr(xxx,1) >250
           CGMwholeManual2 = CGMwholeManual2 + 1;
          end
          if (sgcarr(xxx,1)>=70)&&(sgcarr(xxx,1)<=180)
             CGMwholeManual3=CGMwholeManual3 + 1;
          end  
         if(sgcarr(xxx,1)>=70) && (sgcarr(xxx,1)<=150)
             CGMwholeManual4 =CGMwholeManual4 +1;
         end  
          if sgcarr(xxx,1)<70
             CGMwholeManual5 =CGMwholeManual5 + 1;
          end  
          if sgcarr(xxx,1) <54
             CGMwholeManual6 =CGMwholeManual6 + 1;
          end
     
     end
      
     end
     
     
     ... calculating percentages
         
 PercentagetimeCGMdayAuto1 = (CGMdayAuto1*100)/(288*180);
 PercentagetimeCGMdayAuto2 = (CGMdayAuto2*100)/(288*180);
 PercentagetimeCGMdayAuto3 = (CGMdayAuto3*100)/(288*180);
 PercentagetimeCGMdayAuto4 = (CGMdayAuto4*100)/(288*180);
 PercentagetimeCGMdayAuto5 = (CGMdayAuto5*100)/(288*180);
 PercentagetimeCGMdayAuto6 = (CGMdayAuto6*100)/(288*180);
 PercentagetimeCGMnightAuto1 = (CGMnightAuto1*100)/(288*180);
  PercentagetimeCGMnightAuto2 = (CGMnightAuto2*100)/(288*180);
   PercentagetimeCGMnightAuto3 = (CGMnightAuto3*100)/(288*180);
    PercentagetimeCGMnightAuto4 = (CGMnightAuto4*100)/(288*180);
     PercentagetimeCGMnightAuto5 = (CGMnightAuto5*100)/(288*180);
      PercentagetimeCGMnightAuto6 = (CGMnightAuto6*100)/(288*180);
       PercentagetimeCGMwholeAuto1 = (CGMwholeAuto1*100)/(288*180);
        PercentagetimeCGMwholeAuto2 = (CGMwholeAuto2*100)/(288*180);
         PercentagetimeCGMwholeAuto3 = (CGMwholeAuto3*100)/(288*180);
          PercentagetimeCGMwholeAuto4 = (CGMwholeAuto4*100)/(288*180);
           PercentagetimeCGMwholeAuto5 = (CGMwholeAuto5*100)/(288*180);
            PercentagetimeCGMwholeAuto6 = (CGMwholeAuto6*100)/(288*180);
 PercentagetimeCGMdayManual1 = (CGMdayManual1*100)/(288*180);
  PercentagetimeCGMdayManual2 = (CGMdayManual2*100)/(288*180);
   PercentagetimeCGMdayManual3 = (CGMdayManual3*100)/(288*180);
    PercentagetimeCGMdayManual4 = (CGMdayManual4*100)/(288*180);
     PercentagetimeCGMdayManual5 = (CGMdayManual5*100)/(288*180);
      PercentagetimeCGMdayManual6 = (CGMdayManual6*100)/(288*180);
 PercentagetimeCGMnightManual1 = (CGMnightManual1*100)/(288*180);
 PercentagetimeCGMnightManual2 = (CGMnightManual2*100)/(288*180);
 PercentagetimeCGMnightManual3 = (CGMnightManual3*100)/(288*180);
 PercentagetimeCGMnightManual4 = (CGMnightManual4*100)/(288*180);
 PercentagetimeCGMnightManual5 = (CGMnightManual5*100)/(288*180);
 PercentagetimeCGMnightManual6 = (CGMnightManual6*100)/(288*180);
 PercentagetimeCGMwholeManual1 = (CGMwholeManual1*100)/(288*180);
 PercentagetimeCGMwholeManual2 = (CGMwholeManual2*100)/(288*180);
 PercentagetimeCGMwholeManual3 = (CGMwholeManual3*100)/(288*180);
 PercentagetimeCGMwholeManual4 = (CGMwholeManual4*100)/(288*180);
 PercentagetimeCGMwholeManual5 = (CGMwholeManual5*100)/(288*180);
 PercentagetimeCGMwholeManual6 = (CGMwholeManual6*100)/(288*180);
    
 
 result =[PercentagetimeCGMdayAuto1 PercentagetimeCGMdayAuto2 PercentagetimeCGMdayAuto3 PercentagetimeCGMdayAuto4 PercentagetimeCGMdayAuto5 PercentagetimeCGMdayAuto6 PercentagetimeCGMnightAuto1 PercentagetimeCGMnightAuto2 PercentagetimeCGMnightAuto3 PercentagetimeCGMnightAuto4 PercentagetimeCGMnightAuto5 PercentagetimeCGMnightAuto6 PercentagetimeCGMwholeAuto1 PercentagetimeCGMwholeAuto2 PercentagetimeCGMwholeAuto3 PercentagetimeCGMwholeAuto4 PercentagetimeCGMwholeAuto5 PercentagetimeCGMwholeAuto6 ;
    PercentagetimeCGMdayManual1 PercentagetimeCGMdayManual2 PercentagetimeCGMdayManual3 PercentagetimeCGMdayManual4 PercentagetimeCGMdayManual5 PercentagetimeCGMdayManual6 PercentagetimeCGMnightManual1 PercentagetimeCGMnightManual2 PercentagetimeCGMnightManual3 PercentagetimeCGMnightManual4 PercentagetimeCGMnightManual5 PercentagetimeCGMnightManual6  PercentagetimeCGMwholeManual1  PercentagetimeCGMwholeManual2  PercentagetimeCGMwholeManual3  PercentagetimeCGMwholeManual4  PercentagetimeCGMwholeManual5  PercentagetimeCGMwholeManual6];
Result = array2table(result);
ti = readtable('Results.csv');

writetable(Result,'Results.csv');
mat1 = ones(1168);
mat1 = array2table(mat1);
mat1 = mat1(:,1);
mat2 = zeros(600);
mat2 = array2table(mat2);
mat2 = mat2(:,1);
