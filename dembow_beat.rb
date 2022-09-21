# Welcome to Sonic Pi

define :dembow_beat do
  in_thread do
    2.times do
      sample :bd_zum, amp: 2
      sleep 1
    end
  end
  
  in_thread do
    2.times do
      sleep 0.75
      sample :elec_hi_snare, amp: 2.5
    end
    sleep 0.25
    puts beat
    sample :drum_snare_soft, amp:2 if beat.round%4==0
  end
end

