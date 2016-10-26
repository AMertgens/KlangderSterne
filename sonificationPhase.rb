require 'csv'
puts "start"
data = CSV.parse(File.read("/Users/andreasmertgens/Desktop/kds_v2/Python/Phase.csv"), {:headers => true, :header_converters => :symbol, converters: :all})
puts "data loaded"
$hibmag= 0
$lobmag = 200
$hibmag2= 0
$lobmag2 = 200

data.each do |line|
  bmag1 = line[1].to_f
  bmag2 = line[2].to_f
  if bmag1 > $hibmag
    $hibmag = bmag1
  elsif bmag1 < $lobmag and bmag2 > 0.0
    $lobmag = bmag1
  end
  if bmag2 > $hibmag2
    $hibmag2 = bmag2
  elsif bmag2 < $lobmag2 and bmag2 > 0.0
    $lobmag2 = bmag2
  end
end

in_thread do
  puts "inthread"
  13.times do
    data.each do |line|
      phase = line[1]
      factor = (phase -($lobmag))/($hibmag - $lobmag)
        puts "phase",phase
        play ((factor * 20)+50), pan: 1, attack: 0.03, release: 0.02
        sleep 0.08

      end
    end
  end
  in_thread do
    puts "inthread"
    20.times do
      data.each do |line|
        use_synth :dtri
        phase = line[2]
        puts "phase",phase
        factor = (phase -($lobmag2))/($hibmag2 - $lobmag2)
      play ((factor * 20)+50), pan:-1, attack: 0.03, release: 0.02
      sleep 0.051
      
    end
  end
end


