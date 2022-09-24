use_bpm :link
set_link_bpm! 50
chords = []

define :rhythm do
  in_thread do
    2.times do
      in_thread do
        2.times do
          sample :bd_zum, amp: 0.75
          sleep 1
        end
      end
      
      in_thread do
        2.times do
          sleep 0.75
          sample :elec_hi_snare, amp: 0.75
        end
        sleep 0.25
        puts beat
        sample :drum_snare_soft, amp: 1 if beat.round%4==0
      end
      sleep 2
    end
  end
end



define :wah_chords_pl do |chord_|
  use_synth :tb303
  in_thread do
    with_fx :echo, phase: 2, mix: 0.75, decay: 1, decay_slide: 4, amp: 0.5 do
      2.times do
        play_chord chord_, sustain: 0.125, attack: 0, cutoff: 100
        sleep 0.25
      end
      4.times do
        play_chord chord_, sustain: 0.125, attack: 0, cutoff: 100
        sleep 0.325
end end end end

define :bass_pl do |chord_|
  in_thread do
    [-1,-1,0,-1, 1].each do |octave|
      sleep 0.25
      with_synth :fm  do
        with_octave octave -1 do
          play chord_[0], res: 0.9, amp: 0.5
        end
      end
      sleep choose([0.5, 0.25, 0.75])
end end end

define :pulse_pl do |seed, chord_|
  in_thread do
    use_random_seed seed
    puts "random seed", current_random_seed
    7.times do
      with_fx :reverb, room: 0.9 do
        with_synth :pulse do
          play choose(chord_), decay: 0, sustain: 0.125, amp: 0.30
        end
      end
      sleep choose([0.25, 0.5, 0.25, 1])
    end
  end
end

live_loop :song do
  16.times do
    chords = [[:b, :M], [:gb, :M], [:e, :M], [:b, :M],
              [:a, :M], [:g, :M7], [:gb4, :add4], [:gb, :M]]
    ch = (sync :current_chord)[:ch]
    pulse_pl 2, ch
    bass_pl ch
    wah_chords_pl ch
    sample :loop_amen, beat_stretch: 4, amp: 1.5
  end
  16.times do
    chords = [[:g, :M], [:g, :M],[:a, :M], [:b, :m]]
    ch = (sync :current_chord)[:ch]
    pulse_pl 345, ch
    bass_pl ch
    wah_chords_pl ch
    rhythm
  end
end

comment do
  with_fx :autotuner do |autotune|
    #sample "/home/emmanuel/Documents/perreo-cyborg-dataista/Disco Ordinado/hist.wav", amp: 4, formant_ratio: 0
    live_loop :test_in do
      sync :next_chord
      control autotune, note: current_chord[0]
    end
  end
  
  with_fx :autotuner do |c|
    live_loop :test_in1 do
      sync :next_chord
      control c, formant_ratio: 1, note: current_chord[0] - 24
    end
    
  end
  live_loop :hist do
    with_fx :compressor, slope_above: 2, threshold: 0.1 do
      sample "/home/emmanuel/Documents/perreo-cyborg-dataista/Disco Ordinado/hist3.wav", pitch_stretch: 16
    end
    sleep 16
  end
end

live_loop :beat do
  set_link_bpm! current_bpm + 1 if current_bpm < 110
  sleep 1
end

live_loop :chords do
  cue :current_chord, ch: chord(*chords.tick)
  4.times do
    sync :beat
  end
end


