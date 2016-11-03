##########################
#parse csv files and store data in variables


require 'csv'
puts "start"
data = CSV.parse(File.read("/Users/andreasmertgens/Desktop/kds_v2/Python/Data/v466.csv"), {:headers => true, :header_converters => :symbol})
data2 = CSV.parse(File.read("/Users/andreasmertgens/Desktop/kds_v2/Python/Data/2433.csv"), {:headers => true, :header_converters => :symbol})
data3 = CSV.parse(File.read("/Users/andreasmertgens/Desktop/kds_v2/Python/Transformation/Phase.csv"), {:headers => true, :header_converters => :symbol, converters: :all})
puts "data loaded"

##########################
#Calculating min and max values for all values
#these are used to later map all value to a "factor" value between 0 and 1


$hiphase= 0
$lophase = 200
$hiphase2= 0
$lophase2 = 200

data3.each do |line|
  bmag1 = line[1].to_f
  bmag2 = line[2].to_f
  if bmag1 > $hiphase
    $hiphase = bmag1
  elsif bmag1 < $lophase and bmag2 > 0.0
    $lophase = bmag1
  end
  if bmag2 > $hiphase2
    $hiphase2 = bmag2
  elsif bmag2 < $lophase2 and bmag2 > 0.0
    $lophase2 = bmag2
  end
end

$hibmag= 0
$lobmag = 200
$hibmag2= 0
$lobmag2 = 200

data.each do |line|
  bmag1 = line[:bmag].to_f
  
  if bmag1 > $hibmag
    $hibmag = bmag1
  elsif bmag1 < $lobmag and bmag1 > 0.0
    $lobmag = bmag1
  end
  
end
data2.each do |line|
  bmag1 = line[:bmag].to_f
  if bmag1 > $hibmag2
    $hibmag2 = bmag1
  elsif bmag1 < $lobmag2 and bmag1 > 0.0
    $lobmag2 = bmag1
  end
end
puts "high",$hibmag
puts "low",$lobmag
puts "high2",$hibmag2
puts "low2",$lobmag2

##########################
#Sonification of the bmag brightness values over all photographic plates
#using samples from a prepared piano


use_sample_pack "/Users/andreasmertgens/Desktop/kds_v2/Python/SampleFolder"

in_thread do
  data.each do |line|
    bmag = line[:bmag].to_f
    err = line[:bmagerr].to_f
    puts bmag
    ##########################
    # the "factor" is calculated using the previously established min/max values
    # it is a value between 0 and 1
    
    factor = (bmag -($lobmag))/($hibmag - $lobmag)

    with_fx :reverb, room: 0.3 do

    ##################
    # the factor value is used to modify the playback speed and thus pitch of the sample

      sample :BELL, pan: 0, rate: (factor*3)

    end
    sleep 0.5


  end
end

##########################
#the same steps are applied to the data of the 2nd star
#the stars are panned to the left and right audio channel respectivly.

in_thread do
  data2.each do |line|
    bmag = line[:bmag].to_f
    factor = (bmag -($lobmag2))/($hibmag2 - $lobmag2)
    with_fx :reverb, room: 0.3  do
      sample :DEEP, pan:0, rate: (factor*3)
      
    end
    sleep 0.5
    
    
  end
end

##########################
#An additional layer of sonifcation is based on the avegrage brightness that each star
#has wihtin its respective period
# since there are only 100 values for each star and the playback speed has high in order
#to make the variation in the stars brightness audible, the playback is looped


in_thread do
  puts "inthread"
  13.times do
    data3.each do |line|
      phase = line[1]
      factor = (phase -($lophase))/($hiphase - $lophase)
    puts "phase",phase
    # (((factor+1) * 50)+20)
    # the resulting number (between 20 and 70) is used as a midi note
    play (((factor+1) * 48)), pan: 0.5, attack: 0.03, release: 0.02
    sleep 0.3

  end
end
end
in_thread do
  puts "inthread"
  20.times do
    data3.each do |line|
      use_synth :dtri
      phase = line[2]
      puts "phase",phase
      factor = (phase -($lophase2))/($hiphase2 - $lophase2)
      play (((factor+1) * 48)), pan:-0.5, attack: 0.03, release: 0.02
      sleep 0.2
      
    end
  end
end

