chords = [[:fs, :m, 2], [:b, :m, 2], [:e, :m, 2],
          [:a, :M, 2], [:D, :M, 4], [:b, :m, 4]]



define :arpeggiator do |seed, chord_, dur|
  in_thread do
    use_random_seed seed
    with_fx :reverb, room: 0.9 do
      with_synth :winwood_lead do
        play choose(chord_), decay: 0, sustain: 0.125, amp: 0.30
      end
      sleep dur
    end
  end
end

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


live_loop :song do
  ch = (sync :current_chord)
  in_thread do
    with_fx :ping_pong do
      with_synth :prophet do
        sleep 0.5
        play ch[:ch][0] - 12
      end
    end
  end
  
  in_thread do
    with_fx :flanger do
      with_synth :chiplead do
        use_random_seed 32
        times = shuffle((ring 0.5, 0.25, 0.25)[0..ch[:dur]*2])
        play_pattern_timed shuffle((ring *ch[:ch])[0..ch[:dur]]*2), times, amp: 0.5
      end
    end
  end
  in_thread do
    with_fx :autotuner, note: ch[:ch][0] do
      sample :guit_e_slide, rate: 1, beat_stretch: ch[:dur]
      ch[:dur].times do
        sleep 1
      end
    end
  end
end

live_loop :cheap_drums do
  ch = (sync :current_chord)
  #rhythm
  in_thread do
    sample :loop_amen, finish: 0.25*ch[:dur], beat_stretch: 4
    ch[:dur].times do
      sample :loop_perc2, finish: 1, beat_stretch: 1
      
      #sample :drum_heavy_kick
      sleep 1
    end
  end
end



#####################

live_loop :beat do
  set_link_bpm! current_bpm + 1 if current_bpm < 110
  sleep 1
end

live_loop :chords do
  symbols = chords.tick
  cue :current_chord, ch: chord(*symbols[0,2]), dur: symbols[2]
  sleep symbols[2]
end