require 'test_helper'

class RecipientTest < ActiveSupport::TestCase
  test "recipient not empty" do
    recipient = Recipient.new
    assert recipient.invalid?, "recipient should be invalid"
    assert recipient.errors[:first_name].any?, "first name should not be empty" 
    assert recipient.errors[:last_name].any?, "last name should not be empty"
    assert recipient.errors[:email].any?, "email should not be empty"
    assert recipient.errors[:relation].any?, "relation should not be empty"
    assert recipient.errors[:sender_id].any?, "an recipient should have a sender"
  end
  
  def new_recipient(name,lname,email)
    Recipient.new(:first_name => name,
                  :last_name => lname,
                  :sender_id => 1,
                  :email => email)
  end
  
  test "recipient has a valid e-mail" do
    ok = %W{ ion@balon.com
             aurel.vlaicu@aure.vlaicu.co.uk
             maricel_patrunjel@m-p.co.uk
             tankuri!T34@[192.168.1.2]
             mos.craciun#mail@primaria-brasov.bv.ro
             12carctere$d%l&o'd*a+p-s/a=?^`{|}~d3@coolmail.dot}
    bad = %W{ "mos\ ion"@mail.com
              alex.lapusneanu@palat
              dima..cantemir@histo.fr
              nu_mai_am_adrese@domeniu.e
              arond@arond@mail.com
              @email.com
              .punct@mail.com
              altpunct.@mail.com
              iarpunct@mail.com.
              caractere%d(d)l[s]a\a,dq>e<s@carac.com
              demoniuinvalid@s!#~`$%^&*()+=\|{}]["':;/?><,.com              
            }
    ok.each do |t|
      assert new_recipient('nume', 'prenume', t).valid?, "#{t} should be ok"
    end
    
    bad.each do |t|
      assert new_recipient('nume', 'preume', t).invalid?, "#{t} should be invalid"
    end
  end
  
  test "recipient has a valid name" do
    ok = %w{ ion
             maria
             ana-maria
             ana maria
             john al 3-lea
           }
    bad = %W{ i
              ~`!@#)({}[]\|"':;/?.,><+=-_1234567890
            }
    ok.each do |t|
      assert new_recipient(t, 'prenume', 'email@domeniu.com').valid?, "#{t} name should be ok"
      assert new_recipient('nume', t, 'email@domeniu.com').valid?, "#{t} last name should be ok"
    end
    
    bad.each do |t|
      assert new_recipient(t, 'prenume', 'email@domeniu.com').invalid?, "#{t} name shoul be invalid"
      assert new_recipient('nume', t, 'email@domeniu.com').invalid?, "#{t} last name shoul be invalid"
    end
  end
end
