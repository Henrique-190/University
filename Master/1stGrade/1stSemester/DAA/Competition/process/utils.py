import numpy as np
# funções criadas, mas que acabaram por não ser utilizadas
# deteta outliers através da IQR DISTANCE e imprime métricas adequadas
def detect_outliers_IQR(df,dataset,column_name):
   #Calculate the Q1:
   Q1 = np.percentile(df, 25)
   #Calculate the Q3:
   Q3 = np.percentile(df, 75)
   #Calculatedf_day1 the IQR:
   IQR=Q3-Q1
   # Upper bound
   upper = np.where(df >= (Q3+1.5*IQR))
   # Lower bound
   lower = np.where(df <= (Q1-1.5*IQR))
   #Outliers
   outliers = df[((df<(Q1-1.5*IQR)) | (df>(Q3+1.5*IQR)))]
    
   print("number of outliers: "+ str(len(outliers)))
   print("max outlier value: "+ str(outliers.max()))
   print("min of outliers: "+ str(outliers.min()))
   print("Percentage of outliers: "+ str(len(outliers)/len(df) * 100))
    
   extreme_values = dataset[(dataset[column_name] > outliers.min()) & (dataset[column_name] < outliers.max())]

   if len(extreme_values) > 0:
       inc_not_0_high = extreme_values[extreme_values['incidents'] >= 3]
       inc_not_0_low = extreme_values[extreme_values['incidents'] <= 1]
       inc_not_0_med = extreme_values[extreme_values['incidents'] == 2]
    
       high_rate = len(inc_not_0_high)/len(extreme_values) * 100
       low_rate = len(inc_not_0_low)/len(extreme_values) * 100
       medium_rate = len(inc_not_0_med)/len(extreme_values) * 100
       print("Percentage of outliers for incidents with High Rate or more: " + str(high_rate))
       print("Percentage of outliers for incidents with Medium Rate: " + str(medium_rate))
       print("Percentage of outliers for incidents with Low Rate or less: " + str(low_rate))

# igual à de cima, mas trata de acordo com a percentagem de outliers
def process_outliers_by_number(df, columns, flag):
    if flag == 1:
        # Use IQR distance to detect outliers
        for col in columns:
            median = df[col].median()
            lower_quartile = df[col].quantile(0.25)
            upper_quartile = df[col].quantile(0.75)
            iqr = upper_quartile - lower_quartile

            # Find the rows with outliers
            outliers = df[(df[col] < lower_quartile - 1.5 * iqr) | (df[col] > upper_quartile + 1.5 * iqr)]
            indices = outliers.index
            outliers_per = len(outliers)/len(df[col] * 100)

            # Process the outliers according to the specified method
            if outliers_per <= 6:
                df = df.drop(indices)
            elif outliers_per <= 20:
                df.loc[indices, col] = df[col].mean()
            elif outliers_per <= 60:
                df.loc[indices, col] = median
            else:
                df.loc[indices, col] = df[col].mode()[0]
            
    elif flag == 2:
        # Use MAD to detect outliers
        for col in columns:
            median = df[col].median()
            mad = np.mean(np.abs(df[col] - median))

            # Find the rows with outliers
            outliers = df[(df[col] - median).abs() > 3*mad]
            indices = outliers.index
            outliers_per = len(outliers)/len(df[col] * 100)

            # Process the outliers according to the specified method
            if outliers_per <= 6:
                df = df.drop(indices)
            elif outliers_per <= 20:
                df.loc[indices, col] = df[col].mean()
            elif outliers_per <= 60:
                  df.loc[indices, col] = median
            else:
                df.loc[indices, col] = df[col].mode()[0]
                
    else:
        raise ValueError("Invalid flag. Must be 1 (IQR) or 2 (MAD).")

    return df
    