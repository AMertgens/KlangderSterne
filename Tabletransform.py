import csv
#### this script parses the original data files and calculates the average brightness
#### that is measured for a specific section of it's phase
#### eg: in the first 10th of it's phase all values with a phase between 0.00 and 0.10 would
#### be a added and then divided by their number
#### the resulting data represent the "average phase" of a star and clearly shows
#### a dip in brightness corresponding to the moment the two stars of the system overlap 
#### and only one star can be "seen" from earth, thus appearing less bright than both stars side by side




with open("/Users/andreasmertgens/Desktop/kds_v2/Python/PhaseGcyg.csv",newline="") as csvfile:
        bmagval = csv.reader(csvfile, delimiter=",", quotechar = '|')

        rowlist = []
        for row in bmagval:
          rowlist.append(row)
        #print (rowlist)
        phasedict = dict()

		# the original file is parsed and a hash dict is created mapping each division of the period (here 0,01)
		# to all the brightness values ocuring during this time
		
        for ph in range(1, 101, 1 ):
          #print (ph)
          vlist = []
          for row in rowlist:
              #print (row[0],row[2])
              if row[2] != "PHASE" :
                  
                  if (float(row[2])*100) <= ph and (float(row[2])*100) > (ph - 1):
                      vlist.append(float(row[0]))
                      #print (vlist)
              
                
          #print ("fertig")
          ## the average value for each phase section is calculated, if there are on values
          ## the average will be set to 0, this has to be cleaned up manually afterwards :-/
          ## working on a better solution for this.... 
          if len(vlist) > 0: 
            phasedict[ph] = sum(vlist)/len(vlist)
          else:
            phasedict[ph] = 0
          #print (phasedict)
with open("/Users/andreasmertgens/Desktop/kds_v2/Python/Phasev466.csv",newline="") as csvfile:
        bmagval = csv.reader(csvfile, delimiter=",", quotechar = '|')

        rowlist = []
        for row in bmagval:
          rowlist.append(row)
        #print (rowlist)
        phasedict2 = dict()
        for ph in range(1, 101, 1 ):
          #print (ph)
          vlist = []
          for row in rowlist:
              #print (row[0],row[2])
              if row[1] != "PHASE" :
                  
                  if (float(row[1])*100) <= ph and (float(row[1])*100) > (ph - 1):
                      vlist.append(float(row[0]))
                      #print (vlist)
              
                
          #print ("fertig")
          if len(vlist) > 0:                   
            phasedict2[ph] = sum(vlist)/len(vlist)
          else:
            phasedict2[ph] = 0
          #print (phasedict)
print (phasedict)
print (phasedict2)

## after both files have been parsed, the resulting dictionaries are written into a new file
## this, as of right now, has to be cleaned up manually before it can be fed into Sonic Pi
## and the acutal sonification programm.
with open('result2.csv', 'w', newline='') as csvfile:
    
    fieldnames = ['Phase', 'bmagAVGG','bmagAVG466']
    res = csv.DictWriter(csvfile, fieldnames=fieldnames)
    for val in phasedict:
      res.writerow({"Phase": val, "bmagAVGG":  phasedict[val], 'bmagAVG466':  phasedict2[val]})
    

          
          
