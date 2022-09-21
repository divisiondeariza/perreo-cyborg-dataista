use_bpm 100
chords = [[:b, :M], [:gb, :M], [:e, :M], [:b, :M],
          [:a, :M], [:g, :M7], [:gb4, :add4], [:gb, :M]]
#chords = [[:g, :M], [:g, :M],[:a, :M], [:b, :m]]
current_chord = []

live_loop :chord_dispatcher do
  chord_symbol = chords.tick
  current_chord = chord(chord_symbol[0], chord_symbol[1])
  sync :next_chord
end

live_loop :beat do
  sample :bd_zum, amp: 2
  sleep 1
end

live_loop :dembow do
  sync :beat
  2.times do
    sleep 0.75
    sample :elec_hi_snare, amp: 2.5
  end
  sleep 0.25
  sample :drum_snare_soft, amp:2 if tick%2==0
end

define :wah_chords_pl do
  use_synth :tb303
  in_thread do
    2.times do
      play_chord current_chord, amp: 1, sustain: 0.125, attack: 0, cutoff: 100
      sleep 0.25
    end
    4.times do
      play_chord current_chord, amp: 1, sustain: 0.125, attack: 0, cutoff: 100
      sleep 0.325
end end end

define :bass_pl do
  in_thread do
    [-1,-1,0,-1, 1].each do |octave|
      sleep 0.25
      with_synth :fm  do
        with_octave octave -1 do
          play current_chord[0], res: 0.9
        end
      end
      sleep choose([0.5, 0.25, 0.75])
end end end

define :pulse_pl do
  in_thread do
    use_random_seed (ring 345, 2)[(beat/16).round]
    7.times do
      with_synth :pulse do
        play choose(current_chord), decay: 0, sustain: 0.125, amp: 0.75
      end
      sleep choose([0.25, 0.5, 0.25, 1])
    end
    
  end
end

live_loop :ambient do
  
  16.times do
    sync :beat
    chords = [[:b, :M], [:gb, :M], [:e, :M], [:b, :M],
              [:a, :M], [:g, :M7], [:gb4, :add4], [:gb, :M]]
    if beat > 16 then pulse_pl end
    bass_pl
    wah_chords_pl
    sample :loop_amen, beat_stretch: 4, amp: 1.5
    sleep 3.5
    cue :next_chord
  end
  16.times do
    sync :beat
    chords = [[:g, :M], [:g, :M],[:a, :M], [:b, :m]]
    pulse_pl
    bass_pl
    wah_chords_pl
    sample :loop_amen, beat_stretch: 4, amp: 1.5
    sleep 3.5
    cue :next_chord
  end
end

