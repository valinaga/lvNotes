desc "Send mailing"
task :send_mailing => :environment do
  while(true) do
    letter = Letter.next_for_delivery
    if letter
      UserMailer.send_notification(letter).deliver
    else
      sleep 30
    end
  end
end