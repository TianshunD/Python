

if __name__ != '__lib__':
    def outputSchema(empty):
        return lambda x: x



@outputSchema("fromAverage:double")
def getAverage(a,b):
    cpmList = []
    #extract cpm values
    #for record in cpm:
        #cpmList.append(record[0])
        #cpmList.append(record[1])
        
    #calculate inner fences and outer fences
    #inner_fences, outer_fences = getOutlierRanges(cpmList)
    
    passenger_sum = 0.0
    fare_sum = 0.0
    #sum up cpm
    for record in a:
        passenger_sum += record[0]
    for record in b:
        fare_sum += record[0]
    if passenger_sum == 0:
        return 0;
    else:
        return fare_sum/passenger_sum
   


# In[ ]:




# In[ ]:



