# Welcome to Sonic Pi
use_bpm 100

live_loop :beat do
  sample :bd_zum, amp: 2
  sleep 1
end

define :dembow do
  sync :beat
  2.times do
    sleep 0.75
    sample :elec_hi_snare, amp:2#, cutoff: rrand_i(80, 100)
  end
  sleep 0.25
  sample :drum_snare_soft, amp:2 if tick%2==0
end

define :ambient do
  
  use_synth :tb303
  chord_list =  [[:b, :M], [:gb, :M], [:e, :M], [:b, :M],
                 [:a, :M], [:g, :M7], [:gb4, :add4], [:gb, :M]]
  chord_list = [[:g, :M], [:g, :M],[:a, :M], [:b, :m]]
  #current_chord = (ring  *current_chord)[local_tick]
  #puts current_chord
  
  chord_list.each do |current_chord|
    sync :beat
    current_chord = (chord current_chord[0], current_chord[1])
    puts current_chord
    in_thread do
      [-1,-1,0,-1, 1].each do |octave|
        sleep 0.25
        with_synth :fm  do
          with_octave octave -1 do
            play current_chord[0], res: 0.9
          end
        end
        sleep choose([0.5, 0.25, 0.75])
      end
    end
    in_thread do
      2.times do
        play_chord current_chord, amp: 1, sustain: 0.125, attack: 0, cutoff: 100
        sleep 0.25
      end
      4.times do
        play_chord current_chord, amp: 1, sustain: 0.125, attack: 0, cutoff: 100
        sleep 0.325
      end
    end
    
    in_thread do
      with_synth :dark_ambience do
        #play_chord current_chord -12, amp: 3, attack: 0, sustain: 2, decay: 1
      end
    end
    in_thread do
      with_random_seed (ring 345,1,2,3)[0] do
        7.times do
          with_synth :pulse do
            play choose(current_chord), decay: 0, sustain: 0.125, amp: 0.75
          end
          sleep choose([0.25, 0.5, 0.25, 1])
        end
      end
    end
    sleep 3.5
  end
end

live_loop :song do
  sync :beat
  2.times do
    sync :beat
    sample :loop_amen, beat_stretch: 4
    sleep 3
  end
  
  2.times do
    sync :beat
    sample :loop_amen, beat_stretch: 4
    sleep 1
  end
  
  5.times do
    in_thread do
      4.times do
        sync :beat
        sample :loop_amen, beat_stretch: 4
        sleep 3
      end
    end
    in_thread do
      8.times do
        dembow
      end
    end
    ambient
  end
end