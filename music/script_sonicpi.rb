#New version Aug 2024
#set osc stuff and the dir solenoids where the loops are
use_osc "127.0.0.1", 12000
require 'csv'
solenoids = '/Users/xaviergonzalez/Library/Mobile Documents/com~apple~CloudDocs/Desktop/9216 TIMMD/music/sample_audio/loops'

#set bpm
bpm = 122
use_bpm bpm

#32 bets in each loop
n_beats = 32

#file with metadata
loops = CSV.parse(File.read("/Users/xaviergonzalez/Library/Mobile Documents/com~apple~CloudDocs/Desktop/9216 TIMMD/music/loops_metadata.csv"), headers: true)

note = 0
velocity = 0

amp_dict = {}
#indexes of file to be played
tracks = [1,1,1, 1]

#one way of definig the tracks via osc
live_loop :foo do
  use_real_time
  t0,t1, t2,t3 = sync "/osc*/trigger/prophet"
  tracks2 = [t0,t1, t2,t3]
end

#midi control not used
live_loop:midi_control do
  chan, amplitude = sync "/midi:midi_mix:1/control_change"
  amp_dict = amp_dict.merge({chan => amplitude/127.0})
end

#midi control not used
live_loop:midi_control_2 do
  note, intensity = sync "/midi:midi_mix:1/note_on"
  if (note == 25)
    #print(step)
  end
  if (note == 26)
    #print(note)
  end
end

#control variables not used
next_step = 'ft_drums'
step = 'full'

#starts the main loop
live_loop:hh do
  
  #osc stuff not used
  note = 0
  osc "/hello/world"
  tracks = [96,432,13,166]
  
  #track ids and names, bpms, and key from loops_metadata.csv
  track1_d = loops[tracks[0]]['file_name']
  track2_d = loops[tracks[1]]['file_name']
  track3_d = loops[tracks[2]]['file_name']
  #track40_o = loops[tracks[40]]['file_name']
  
  bpm1 = loops[tracks[0]]['Bpm']
  bpm2 = loops[tracks[1]]['Bpm']
  bpm3 = loops[tracks[2]]['Bpm']
  
  #print filenames in console
  print(loops[tracks[0]]['file_name'])
  print(  loops[tracks[1]]['file_name'])
  print(  loops[tracks[2]]['file_name'])
  
  #all audio files needs the same duration and 122 bpm, rate adjusted proportinally
  sample solenoids + '/' + track1_d, rate: bpm/bpm1.to_f, amp: 0.7
  sample solenoids + '/' + track2_d, rate: bpm/bpm2.to_f, amp: 1
  sample solenoids + '/' + track3_d, rate: bpm/bpm1.to_f, amp: 0.5
  
  step = next_step
  sleep 32
end
